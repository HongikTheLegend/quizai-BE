from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError

from app.core.security import decode_token
from app.db.supabase import get_supabase
from app.services.session_service import get_answer_stats, submit_answer
from app.websocket.manager import manager

router = APIRouter(tags=["websocket"])


@router.websocket("/sessions/{session_id}/join")
async def session_ws(
    session_id: str,
    websocket: WebSocket,
    nickname: str = "",
    token: str = "",
):
    # JWT 검증
    try:
        payload = decode_token(token)
        user_id: str = payload["sub"]
    except (JWTError, KeyError):
        await websocket.close(code=4001, reason="Unauthorized")
        return

    # 세션 존재 확인 + 역할 결정 (DB 기준)
    supabase = get_supabase()
    session_row = (
        supabase.table("sessions")
        .select("instructor_id")
        .eq("id", session_id)
        .single()
        .execute()
    )
    if not session_row.data:
        await websocket.accept()
        await websocket.send_json({"detail": "Session not found"})
        await websocket.close(code=4004)
        return

    role = "instructor" if session_row.data["instructor_id"] == user_id else "student"

    await manager.connect(session_id, user_id, role, nickname, websocket)

    await manager.broadcast(session_id, {
        "type": "session_joined",
        "user_id": user_id,
        "nickname": nickname,
        "role": role,
        "participant_count": manager.get_participant_count(session_id),
    })

    try:
        while True:
            data = await websocket.receive_json()
            msg_type = data.get("type")

            if role == "instructor":
                if msg_type == "quiz_start":
                    await manager.broadcast(session_id, {
                        "type": "quiz_started",
                        "quiz_id": data.get("quiz_id"),
                    })
                elif msg_type == "reveal_answer":
                    await manager.broadcast(session_id, {
                        "type": "answer_revealed",
                        "quiz_id": data.get("quiz_id"),
                    })
                elif msg_type == "end_session":
                    await manager.broadcast(session_id, {"type": "session_ended"})

            elif role == "student" and msg_type == "submit_answer":
                quiz_id = data.get("quiz_id", "")
                selected_option = data.get("selected_option", "")
                response_time_ms = data.get("response_time_ms", 0)

                try:
                    result = submit_answer(
                        session_id, quiz_id, user_id, selected_option, response_time_ms
                    )
                    await websocket.send_json({"type": "answer_result", **result})

                    stats = get_answer_stats(
                        session_id, quiz_id, manager.get_student_count(session_id)
                    )
                    await manager.send_to_instructors(session_id, {
                        "type": "answer_update",
                        "quiz_id": quiz_id,
                        "answer_count": stats["answer_count"],
                        "response_rate": stats["response_rate"],
                    })
                except Exception as e:
                    await websocket.send_json({"type": "error", "detail": str(e)})

    except WebSocketDisconnect:
        manager.disconnect(session_id, user_id)
        await manager.broadcast(session_id, {
            "type": "session_left",
            "user_id": user_id,
            "nickname": nickname,
            "participant_count": manager.get_participant_count(session_id),
        })
