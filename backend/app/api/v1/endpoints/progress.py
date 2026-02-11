from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime, timezone as dt_timezone
import time
import anyio
from app.db.session import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.schemas.user import ProgressRequest
from app.services.ai_service import ai_service
from app.services.s3_service import s3_service

router = APIRouter()

@router.post("/")
async def progress(
    request: ProgressRequest,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user.get("uid")
    user = db.query(User).filter(User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # 24h Lock Check
    now = datetime.now(dt_timezone.utc)
    is_ticket_usage = False
    if user.last_progressed_at:
        last_at = user.last_progressed_at
        if last_at.tzinfo is None:
            last_at = last_at.replace(tzinfo=dt_timezone.utc)
            
        elapsed_seconds = (now - last_at).total_seconds()
        if elapsed_seconds < 86400:
            if user.tickets > 0:
                is_ticket_usage = True
            else:
                remaining = 86400 - elapsed_seconds
                hours = int(remaining // 3600)
                minutes = int((remaining % 3600) // 60)
                raise HTTPException(
                    status_code=429, 
                    detail=f"Next available in {hours}h {minutes}m"
                )

    # Progression Logic
    before_url = None
    if user.current_image_path:
        before_url = await anyio.to_thread.run_sync(
            s3_service.generate_presigned_url, user.current_image_path
        )

    try:
        if user.step == 0:
            generated_url = await anyio.to_thread.run_sync(
                ai_service.generate_step_0, user.seed
            )
        else:
            actual_before_url = await anyio.to_thread.run_sync(
                s3_service.generate_presigned_url, user.current_image_path
            )
            generated_url = await anyio.to_thread.run_sync(
                ai_service.advance_step, actual_before_url, user.seed, user.step + 1
            )

        if not generated_url:
            raise HTTPException(status_code=500, detail="Generation failed or NSFW blocked all retries")

        # Save to S3
        new_key = f"users/{user_id}/step_{user.step + 1}_{int(time.time())}.png"
        s3_path = await anyio.to_thread.run_sync(
            s3_service.upload_from_url, generated_url, new_key
        )
        
        if not s3_path:
            raise HTTPException(status_code=500, detail="Failed to persist image to storage")

        # Cleanup Old Image
        old_path = user.current_image_path
        
        # Update DB
        user.step += 1
        user.current_image_path = new_key
        user.last_progressed_at = now
        if is_ticket_usage:
            user.tickets -= 1
        
        db.commit()

        # Final S3 Cleanup
        if old_path:
            await anyio.to_thread.run_sync(s3_service.delete_file, old_path)

        after_url = await anyio.to_thread.run_sync(
            s3_service.generate_presigned_url, new_key
        )

        return {
            "status": "success",
            "before_url": before_url,
            "after_url": after_url,
            "new_step": user.step
        }

    except Exception as e:
        db.rollback()
        if isinstance(e, HTTPException):
            raise e
        raise HTTPException(status_code=500, detail=str(e))
