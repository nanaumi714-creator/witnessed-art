from fastapi import APIRouter
from app.api.v1.endpoints import user, progress

api_router = APIRouter()
api_router.include_router(user.router, prefix="/user", tags=["user"])
api_router.include_router(progress.router, prefix="/progress", tags=["progress"])
api_router.include_router(user.router_saved, prefix="/saved-images", tags=["saved-images"])
