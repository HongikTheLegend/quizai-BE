from fastapi import APIRouter

router = APIRouter(prefix="/auth", tags=["auth"])

# POST /auth/register  — 회원가입
# POST /auth/login     — 로그인 (JWT 발급)
# GET  /auth/me        — 내 정보 조회
