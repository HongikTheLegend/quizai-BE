from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import auth, dashboard, lectures, quizzes, sessions, students, websocket

app = FastAPI(title="QuizAI API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "https://quizai.vercel.app",
        "https://quizai-fe.vercel.app",
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type"],
)

app.include_router(auth.router)
app.include_router(lectures.router)
app.include_router(quizzes.router)
app.include_router(sessions.router)
app.include_router(websocket.router)
app.include_router(dashboard.router)
app.include_router(students.router)


@app.get("/health")
def health_check():
    return {"status": "ok"}
