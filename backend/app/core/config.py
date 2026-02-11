from typing import List, Union
from pydantic import AnyHttpUrl, validator
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "Witnessed Art API"
    API_V1_STR: str = "/api/v1"
    
    # DATABASE
    POSTGRES_SERVER: str = "localhost"
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "password"
    POSTGRES_DB: str = "witnessed_art"
    SQLALCHEMY_DATABASE_URI: Union[str, None] = None

    @validator("SQLALCHEMY_DATABASE_URI", pre=True)
    def assemble_db_connection(cls, v: Union[str, None], values: dict) -> str:
        if isinstance(v, str):
            return v
        return f"postgresql://{values.get('POSTGRES_USER')}:{values.get('POSTGRES_PASSWORD')}@{values.get('POSTGRES_SERVER')}/{values.get('POSTGRES_DB')}"

    # CORS
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = []

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    # FIREBASE
    FIREBASE_PROJECT_ID: Union[str, None] = None
    FIREBASE_SERVICE_ACCOUNT_JSON: Union[str, None] = None

    # AWS
    AWS_ACCESS_KEY_ID: Union[str, None] = None
    AWS_SECRET_ACCESS_KEY: Union[str, None] = None
    AWS_S3_BUCKET: Union[str, None] = None
    AWS_REGION: str = "us-east-1"

    # REPLICATE
    REPLICATE_API_TOKEN: Union[str, None] = None

    model_config = SettingsConfigDict(case_sensitive=True, env_file=".env")

settings = Settings()
