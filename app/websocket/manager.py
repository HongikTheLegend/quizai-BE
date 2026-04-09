from fastapi import WebSocket


class ConnectionManager:
    def __init__(self):
        # {session_id: {user_id: {"ws": WebSocket, "role": str, "nickname": str}}}
        self.connections: dict[str, dict[str, dict]] = {}

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
        self.connections[session_id][user_id] = {
            "ws": websocket,
            "role": role,
            "nickname": nickname,
        }

    def disconnect(self, session_id: str, user_id: str):
        session = self.connections.get(session_id, {})
        session.pop(user_id, None)
        if not session:
            self.connections.pop(session_id, None)

    def get_participant_count(self, session_id: str) -> int:
        return len(self.connections.get(session_id, {}))

    def get_student_count(self, session_id: str) -> int:
        return sum(
            1
            for info in self.connections.get(session_id, {}).values()
            if info["role"] == "student"
        )

    async def broadcast(self, session_id: str, message: dict):
        for info in self.connections.get(session_id, {}).values():
            await info["ws"].send_json(message)

    async def send_to_instructors(self, session_id: str, message: dict):
        for info in self.connections.get(session_id, {}).values():
            if info["role"] == "instructor":
                await info["ws"].send_json(message)


manager = ConnectionManager()
