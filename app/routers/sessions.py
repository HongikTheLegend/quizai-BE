from fastapi import APIRouter, Depends, Request

from app.core.dependencies import get_current_user
from app.models.session import AnswerResponse, AnswerSubmit, SessionStart, SessionStartResponse
from app.services.session_service import create_session, get_answer_stats, submit_answer
from app.websocket.manager import manager

router = APIRouter(prefix="/sessions", tags=["sessions"])


@router.post("/start", response_model=SessionStartResponse)
def start_session(
    body: SessionStart,
    request: Request,
    current_user: dict = Depends(get_current_user),
):
    session = create_session(body.quiz_set_id, current_user["sub"], body.time_limit)

    base = str(request.base_url).rstrip("/")
    ws_base = base.replace("http://", "ws://").replace("https://", "wss://")
    ws_url = f"{ws_base}/sessions/{session['id']}/join"

    return SessionStartResponse(
        session_id=session["id"],
        session_code=session["session_code"],
        ws_url=ws_url,
        status=session["status"],
    )


@router.post("/{session_id}/answer", response_model=AnswerResponse)
async def answer(
    session_id: str,
    body: AnswerSubmit,
    current_user: dict = Depends(get_current_user),
):
    result = submit_answer(
        session_id,
        body.quiz_id,
        current_user["sub"],
        body.selected_option,
        body.response_time_ms,
    )

    total_students = manager.get_student_count(session_id)
    stats = get_answer_stats(session_id, body.quiz_id, total_students)
    await manager.send_to_instructors(session_id, {
        "type": "answer_update",
        "quiz_id": body.quiz_id,
        "answer_count": stats["answer_count"],
        "response_rate": stats["response_rate"],
    })

    return AnswerResponse(**result)
