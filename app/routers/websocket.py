from fastapi import APIRouter

router = APIRouter(prefix="/ws", tags=["websocket"])

# WS /ws/session/{session_id}  — 실시간 퀴즈 세션 WebSocket 연결
