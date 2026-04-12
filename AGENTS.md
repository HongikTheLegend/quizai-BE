# AGENTS.md — Claude Code 사용 규칙

이 파일은 Claude Code(AI 코딩 어시스턴트)가 이 프로젝트에서 작업할 때 반드시 따라야 할 규칙을 정의합니다.

---

## 절대 금지 사항

- `.env` 파일을 읽거나 수정하지 말 것. 환경변수 참고는 `.env.example`만 사용
- 환경변수 값(API 키, DB URL, JWT 시크릿 등)을 코드에 하드코딩 금지
- `git push --force` 등 파괴적 git 명령 실행 금지 (사용자가 명시적으로 요청한 경우 제외)
- 사용자 요청 없이 커밋/푸시 실행 금지

---

## 코드 작성 규칙

### 구조
- 라우터(`app/routers/`)는 얇게 유지 — HTTP 처리만
- 비즈니스 로직은 반드시 `app/services/`에만 작성
- WebSocket 연결 관리는 `app/websocket/manager.py`에 집중
- 모든 응답은 `app/models/`의 Pydantic 모델로 타입 명시

### 코드 품질
- 기존 코드를 읽지 않고 수정 제안 금지 — 먼저 Read 후 수정
- 요청 범위를 넘는 리팩토링, 주석 추가, 타입 어노테이션 추가 금지
- 발생할 수 없는 시나리오에 대한 방어 코드 추가 금지
- 한 번만 쓰이는 로직을 위한 헬퍼/유틸 추상화 금지

### 보안
- SQL 인젝션, XSS 등 OWASP Top 10 취약점 유발 코드 작성 금지
- 인증이 필요한 엔드포인트는 반드시 `Depends(get_current_user)` 사용

---

## 파일 수정 시 주의사항

| 파일/디렉토리 | 주의사항 |
|---|---|
| `.env` | 절대 읽거나 수정하지 말 것 |
| `app/core/config.py` | 환경변수 로드 설정 — 변경 시 전체 영향 |
| `app/db/supabase.py` | DB 클라이언트 싱글턴 — 함부로 수정 금지 |
| `app/websocket/manager.py` | 전역 상태(connections, question_index) 관리 — 동시성 주의 |
| `app/main.py` | CORS 설정, 라우터 등록 포함 — 변경 시 프론트 영향 |

---

## 작업 순서 원칙

1. 관련 파일 Read로 현재 구조 파악
2. 변경 범위 최소화
3. 수정 후 로컬 서버 실행으로 동작 확인 (필요 시)
4. 사용자 요청 시에만 git add / commit / push 실행

---

## 기술 스택 참고

- Python 3.11 / FastAPI / Uvicorn
- Supabase (PostgreSQL + REST SDK)
- Anthropic Claude API (`claude-sonnet-4-5`)
- JWT: `python-jose` + `passlib[bcrypt]`
- WebSocket: FastAPI 내장
- 배포: Render (환경변수는 Render 대시보드에서 관리)
