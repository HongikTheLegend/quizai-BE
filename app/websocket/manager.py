import logging

from fastapi import WebSocket

logger = logging.getLogger(__name__)


class ConnectionManager:
    def __init__(self):
        # {session_id: {user_id: {"ws": WebSocket, "role": str, "nickname": str}}}
        self.connections: dict[str, dict[str, dict]] = {}
        # {session_id: int}  현재 진행 중인 문제 인덱스 (-1 = 아직 시작 안 함)
        self.question_index: dict[str, int] = {}

    async def connect(
        self,
        session_id: str,
        user_id: str,
        role: str,
        nickname: str,
        websocket: WebSocket,
    ):
        await websocket.accept()
        if session_id not in self.connections:
            self.connections[session_id] = {}
            self.question_index[session_id] = -1  # 세션 첫 연결 시 인덱스 초기화
        self.connections[session_id][user_id] = {
            "ws": websocket,
            "role": role,
            "nickname": nickname,
        }
        logger.info(
            "[WS] connect | session_id=%s user_id=%s role=%s | 현재 연결 수=%d",
            session_id, user_id, role, len(self.connections[session_id]),
        )

    def disconnect(self, session_id: str, user_id: str):
        session = self.connections.get(session_id, {})
        session.pop(user_id, None)
        if not session:
            self.connections.pop(session_id, None)
            self.question_index.pop(session_id, None)  # 세션 종료 시 인덱스 정리

    def advance_question(self, session_id: str) -> int:
        """다음 문제 인덱스로 이동 후 반환. 세션이 없으면 0부터 시작."""
        current = self.question_index.get(session_id, -1)
        next_index = current + 1
        self.question_index[session_id] = next_index
        logger.info(
            "[WS] advance_question | session_id=%s | index %d -> %d",
            session_id, current, next_index,
        )
        return next_index

    def get_current_question_index(self, session_id: str) -> int:
        return self.question_index.get(session_id, -1)

    def get_participant_count(self, session_id: str) -> int:
        return len(self.connections.get(session_id, {}))

    def get_student_count(self, session_id: str) -> int:
        return sum(
            1
            for info in self.connections.get(session_id, {}).values()
            if info["role"] == "student"
        )

    async def broadcast(self, session_id: str, message: dict):
        # list()로 스냅샷 — 순회 중 disconnect로 dict가 변경되어도 안전
        recipients = list(self.connections.get(session_id, {}).items())
        sent = 0
        for user_id, info in recipients:
            try:
                await info["ws"].send_json(message)
                sent += 1
            except Exception as e:
                logger.warning(
                    "[WS] broadcast 전송 실패 | session_id=%s user_id=%s error=%s",
                    session_id, user_id, e,
                )
        logger.info(
            "[WS] broadcast | session_id=%s | 수신자 수=%d / 전체=%d | type=%s",
            session_id, sent, len(recipients), message.get("type"),
        )

    async def send_to_instructors(self, session_id: str, message: dict):
        recipients = list(self.connections.get(session_id, {}).items())
        for user_id, info in recipients:
            if info["role"] == "instructor":
                try:
                    await info["ws"].send_json(message)
                except Exception as e:
                    logger.warning(
                        "[WS] send_to_instructors 전송 실패 | session_id=%s user_id=%s error=%s",
                        session_id, user_id, e,
                    )


manager = ConnectionManager()
