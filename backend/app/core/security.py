from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import firebase_admin
from firebase_admin import auth, credentials
from app.core.config import settings

security = HTTPBearer(auto_error=False)

# Initialize Firebase Admin
import json
if not firebase_admin._apps:
    if settings.FIREBASE_SERVICE_ACCOUNT_JSON:
        try:
            # JSON文字列かファイルパスかを判定
            if settings.FIREBASE_SERVICE_ACCOUNT_JSON.strip().startswith('{'):
                service_account_info = json.loads(settings.FIREBASE_SERVICE_ACCOUNT_JSON)
                cred = credentials.Certificate(service_account_info)
            else:
                cred = credentials.Certificate(settings.FIREBASE_SERVICE_ACCOUNT_JSON)
            firebase_admin.initialize_app(cred)
        except Exception as e:
            # ローカル開発かつデバッグモードなら警告のみで初期化
            if settings.DEBUG_SKIP_AUTH:
                print(f"Warning: Firebase initialization failed: {e}. Authentication will be skipped.")
                firebase_admin.initialize_app()
            else:
                raise e
    else:
        # Fallback for local dev if not provided (might fail in production)
        firebase_admin.initialize_app()

async def get_current_user(token: HTTPAuthorizationCredentials = Depends(security)):
    if settings.DEBUG_SKIP_AUTH:
        return {"uid": "local-test-user", "email": "test@example.com"}
        
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        decoded_token = auth.verify_id_token(token.credentials)
        return decoded_token
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid authentication credentials: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )

