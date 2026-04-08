from fastapi import APIRouter

router = APIRouter(prefix="/sessions", tags=["sessions"])

# POST /sessions/start           — 세션 시작
# POST /sessions/{id}/answer     — 답안 제출
# GET  /sessions/{id}/result     — 세션 결과 + 이해도 분류
# GET  /sessions/history         — 내 세션 히스토리
