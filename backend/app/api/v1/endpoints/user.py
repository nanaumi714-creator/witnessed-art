from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.schemas.user import UserState
import random
import uuid
import hashlib

router = APIRouter()
router_saved = APIRouter()

@router.post("/init", response_model=UserState)
def init_user(
    timezone: str = "UTC", 
    db: Session = Depends(get_db), 
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user.get("uid")
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

