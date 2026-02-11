from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    user_id: str
    seed: int
    step: int
    current_image_url: Optional[str] = None
    max_save_slots: int
    tickets: int

class UserState(UserBase):
    last_progressed_at: Optional[datetime] = None
    timezone: str
    
    class Config:
        from_attributes = True

class ProgressRequest(BaseModel):
    timestamp: int
