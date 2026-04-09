from pydantic_settings import BaseSettings
from pydantic import Field


class Settings(BaseSettings):
    anthropic_api_key: str = Field(..., alias="ANTHROPIC_API_KEY")
    supabase_url: str = Field(..., alias="SUPABASE_URL")
    supabase_key: str = Field(..., alias="SUPABASE_KEY")
    jwt_secret: str = Field(..., alias="JWT_SECRET")
    frontend_url: str = Field("http://localhost:3000", alias="FRONTEND_URL")

    class Config:
        env_file = ".env"


settings = Settings()