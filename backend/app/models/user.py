from typing import Optional
from sqlalchemy import Column, String, Integer, BigInteger, DateTime, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.base import Base

class User(Base):
    __tablename__ = "users"

    user_id = Column(String, primary_key=True, index=True) # Firebase UID
    seed = Column(BigInteger, nullable=False)
    step = Column(Integer, default=0, nullable=False)
    current_image_path = Column(String, nullable=True)
    last_progressed_at = Column(DateTime(timezone=True), nullable=True)
    max_save_slots = Column(Integer, default=1, nullable=False)
    tickets = Column(Integer, default=0, nullable=False)
    timezone = Column(String, default="UTC", nullable=False)
    notification_enabled = Column(Boolean, default=True, nullable=False)
    notification_hour = Column(Integer, default=12, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    saved_images = relationship("SavedImage", back_populates="owner", cascade="all, delete-orphan")

    @property
    def current_image_url(self) -> Optional[str]:
        if not self.current_image_path:
            return None
        from app.services.s3_service import s3_service
        return s3_service.generate_presigned_url(self.current_image_path)

class SavedImage(Base):
    __tablename__ = "saved_images"

    id = Column(String, primary_key=True, index=True) # UUID
    user_id = Column(String, ForeignKey("users.user_id"), nullable=False)
    image_path = Column(String, nullable=False)
    seed = Column(BigInteger, nullable=False)
    final_step = Column(Integer, nullable=False)
    saved_at = Column(DateTime(timezone=True), server_default=func.now())

    owner = relationship("User", back_populates="saved_images")
