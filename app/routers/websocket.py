import logging

from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from jose import JWTError

from app.core.security import decode_token
from app.db.supabase import get_supabase
from app.services.session_service import get_answer_stats, submit_answer
from app.websocket.manager import manager

logger = logging.getLogger(__name__)
router = APIRouter(tags=["websocket"])

_OPTION_LABELS = ["A", "B", "C", "D"]


def _normalize_option(raw) -> str:
    """selected_option 정규화: int(0~3) → 'A'~'D', str은 대문자 변환."""
    if isinstance(raw, int):
        if 0 <= raw <= 3:
            return _OPTION_LABELS[raw]
        return ""
    return str(raw).upper()


async def _fetch_question_by_index(
    supabase, quiz_set_id: str, index: int, time_limit: int
) -> dict | None:
    """quiz_set_id의 questions 배열에서 index번째 문제를 조회해 브로드캐스트용 payload로 반환.
    index가 범위를 벗어나면 None 반환 (세션 종료 신호로 활용 가능).
    """
    row = (
        supabase.table("quizzes")
        .select("questions")
        .eq("id", quiz_set_id)
        .single()
        .execute()
    )
    if not row.data:
        return None

    questions = row.data.get("questions") or []
    if index >= len(questions):
        return None  # 모든 문제 소진

    question = questions[index]
    options = [f"{opt['label']}. {opt['text']}" for opt in question.get("options", [])]

    return {
        "quiz_id": question["id"],
        "question_index": index,
        "question_total": len(questions),
        "question": question["question"],
        "options": options,
        "time_limit": time_limit,
    }


@router.websocket("/sessions/{session_id}/join")
async def session_ws(
    session_id: str,
    websocket: WebSocket,
    nickname: str = "",
    token: str = "",
):
    logger.info("[WS] 연결 시도 | session_id=%s nickname=%s", session_id, nickname)

    # JWT 검증
    try:
        payload = decode_token(token)
        user_id: str = payload["sub"]
    except (JWTError, KeyError):
        logger.warning("[WS] 인증 실패 | session_id=%s", session_id)
        await websocket.close(code=4001, reason="Unauthorized")
        return

    # 세션 존재 확인 + 역할 결정 (DB 기준)
    supabase = get_supabase()
    session_row = (
        supabase.table("sessions")
        .select("instructor_id, quiz_set_id, time_limit")
        .eq("id", session_id)
        .single()
        .execute()
    )
    if not session_row.data:
        logger.warning("[WS] 세션 없음 | session_id=%s", session_id)
        await websocket.accept()
        await websocket.send_json({"detail": "Session not found"})
        await websocket.close(code=4004)
        return

    session_data = session_row.data
    role = "instructor" if session_data["instructor_id"] == user_id else "student"

    await manager.connect(session_id, user_id, role, nickname, websocket)
    logger.info("[WS] 연결 성공 | session_id=%s user_id=%s role=%s", session_id, user_id, role)

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
                if msg_type == "next_question":
                    next_index = manager.advance_question(session_id)
                    question_payload = await _fetch_question_by_index(
                        supabase, session_data["quiz_set_id"], next_index, session_data["time_limit"]
                    )
                    if question_payload is None:
                        await websocket.send_json({
                            "type": "error",
                            "detail": f"더 이상 문제가 없습니다. (index={next_index})",
                        })
                    else:
                        await manager.broadcast(session_id, {
                            "type": "quiz_started",
                            "payload": question_payload,
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
                selected_option = _normalize_option(data.get("selected_option", ""))
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
        logger.info("[WS] 연결 종료 | session_id=%s user_id=%s role=%s", session_id, user_id, role)
        await manager.broadcast(session_id, {
            "type": "session_left",
            "user_id": user_id,
            "nickname": nickname,
            "participant_count": manager.get_participant_count(session_id),
        })
