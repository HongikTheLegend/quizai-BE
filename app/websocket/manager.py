from fastapi import WebSocket


class ConnectionManager:
    def __init__(self):
        # session_id -> list of connected WebSockets
        self.active_connections: dict[str, list[WebSocket]] = {}

    async def connect(self, session_id: str, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.setdefault(session_id, []).append(websocket)

    def disconnect(self, session_id: str, websocket: WebSocket):
        connections = self.active_connections.get(session_id, [])
        if websocket in connections:
            connections.remove(websocket)

    async def send_to_session(self, session_id: str, message: dict):
        for ws in self.active_connections.get(session_id, []):
            await ws.send_json(message)

    async def broadcast(self, message: dict):
        for connections in self.active_connections.values():
            for ws in connections:
                await ws.send_json(message)


manager = ConnectionManager()
