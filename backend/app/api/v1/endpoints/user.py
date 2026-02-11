from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.schemas.user import UserState, UserInit
import random
import uuid
import hashlib

router = APIRouter()
router_saved = APIRouter()

@router.post("/init", response_model=UserState)
def init_user(
    user_init: UserInit, 
    db: Session = Depends(get_db), 
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user.get("uid")
    timezone = user_init.timezone
    db_user = db.query(User).filter(User.user_id == user_id).first()
    
    if not db_user:
        # Generate seed: SHA256 of UUID4 lower 63 bits
        raw_seed = int(hashlib.sha256(str(uuid.uuid4()).encode()).hexdigest(), 16)
        seed = raw_seed & ((1 << 63) - 1)
        
        db_user = User(
            user_id=user_id,
            seed=seed,
            step=0,
            timezone=timezone
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
    
    return db_user

@router.post("/reset")
def reset_user(
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user.get("uid")
    user = db.query(User).filter(User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Generate new seed
    raw_seed = int(hashlib.sha256(str(uuid.uuid4()).encode()).hexdigest(), 16)
    user.seed = raw_seed & ((1 << 63) - 1)
    user.step = 0
    # Note: We don't delete current_image_path from S3 here to allow "undo" or just let it be overwritten
    # but for true reset we should probably clear it.
    user.current_image_path = None
    db.commit()
    return {"status": "success"}

@router_saved.post("/save")
def save_image(
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    from app.models.user import SavedImage
    user_id = current_user.get("uid")
    user = db.query(User).filter(User.user_id == user_id).first()
    if not user or not user.current_image_path:
        raise HTTPException(status_code=400, detail="Nothing to save")
    
    # Check slots
    saved_count = db.query(SavedImage).filter(SavedImage.user_id == user_id).count()
    if saved_count >= user.max_save_slots:
        raise HTTPException(status_code=403, detail="Save slots full")
    
    # Save current state to permanent collection
    saved = SavedImage(
        id=str(uuid.uuid4()),
        user_id=user_id,
        image_path=user.current_image_path,
        seed=user.seed,
        final_step=user.step
    )
    db.add(saved)
    db.commit()
    return {"status": "success", "id": saved.id}

@router_saved.get("/")
def list_saved_images(
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    from app.models.user import SavedImage
    from app.services.s3_service import s3_service
    user_id = current_user.get("uid")
    saved = db.query(SavedImage).filter(SavedImage.user_id == user_id).all()
    
    results = []
    for item in saved:
        results.append({
            "id": item.id,
            "url": s3_service.generate_presigned_url(item.image_path),
            "step": item.final_step,
            "saved_at": item.saved_at
        })
    return results


