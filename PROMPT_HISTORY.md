# PROMPT_HISTORY.md — Claude Code 주요 프롬프트 기록

이 파일은 Claude Code에 입력한 주요 프롬프트와 그 결과를 기능 구현 순서대로 정리합니다.
새 작업을 완료할 때마다 맨 아래에 항목을 추가해주세요 (작성 규칙은 파일 맨 하단 참고).

---

## 01. 프로젝트 초기 구조 세팅

**커밋:** `0acd941 백엔드 초기 프로젝트 구조 세팅`

**사용한 프롬프트:**
> FastAPI 기반 퀴즈 플랫폼 백엔드를 만들어줘.
> 기술 스택: Python 3.11, FastAPI, Uvicorn, Supabase, Anthropic Claude API, JWT 인증.
> 폴더 구조는 app/routers, app/services, app/models, app/core, app/db, app/websocket 로 분리해줘.
> .env.example 파일도 만들어줘.

**생성된 주요 파일:**
- `app/main.py` — FastAPI 앱 생성, CORS 미들웨어
- `app/core/config.py` — 환경변수 로드 (pydantic Settings)
- `app/core/security.py` — JWT 생성/검증, 비밀번호 해시
- `app/core/dependencies.py` — `get_current_user` 의존성
- `app/db/supabase.py` — Supabase 클라이언트 싱글턴
- `.env.example` — 환경변수 템플릿
- `requirements.txt`

---

## 02. auth 구현 (register / login / me)

**커밋:** `e7d396f feat: auth 구현 (register/login/me)`

**사용한 프롬프트:**
> auth 라우터를 구현해줘.
> POST /auth/register — 이메일, 비밀번호, 이름, role(instructor/student)로 회원가입. JWT 반환.
> POST /auth/login — 이메일+비밀번호 로그인. JWT 반환.
> GET /auth/me — 현재 로그인 사용자 정보 반환.
> 비밀번호는 bcrypt로 해시 저장. Supabase users 테이블 사용.

**생성된 주요 파일:**
- `app/routers/auth.py`
- `app/models/user.py` — `UserCreate`, `UserLogin`, `UserResponse`, `TokenResponse`

---

## 03. lectures 업로드 구현

**커밋:** `9067679 feat: lectures 업로드 구현`

**사용한 프롬프트:**
> 강의록 업로드 API를 구현해줘.
> POST /lectures/upload — PDF, TXT, DOCX 파일 업로드. 텍스트 추출 후 Supabase lectures 테이블에 저장.
> GET /lectures — 내 강의 목록 반환.
> 파일 크기 제한 10MB, 지원 확장자 .pdf/.txt/.docx.

**생성된 주요 파일:**
- `app/routers/lectures.py`
- `app/services/lecture_service.py` — PDF/DOCX/TXT 텍스트 추출
- `app/models/lecture.py`

---

## 04. Claude API 퀴즈 자동 생성

**커밋:** `65934dc feat: Claude API 퀴즈 자동 생성 구현`

**사용한 프롬프트:**
> Claude API로 강의록 텍스트를 분석해서 객관식 4지선다 퀴즈를 자동 생성하는 기능을 구현해줘.
> POST /quizzes/generate — lecture_id, count, quiz_type 입력 받아 Claude API 호출.
> 생성된 퀴즈는 Supabase quizzes 테이블에 저장.
> 문항 형식: question, options(A/B/C/D), answer, explanation.
> GET /quizzes/{lecture_id} — 강의별 퀴즈 목록 반환.

**생성된 주요 파일:**
- `app/routers/quizzes.py`
- `app/services/claude_service.py` — Claude API 호출, JSON 파싱
- `app/services/quiz_service.py`
- `app/models/quiz.py` — `QuizQuestion`, `QuizOption`

**핵심 구현:**
- Claude 응답에서 JSON만 추출 (```코드블록 처리 포함)
- 0-based int 인덱스 → "A"~"D" 레이블 변환 후 저장
- API 실패 시 1회 재시도

---

## 05. WebSocket 실시간 세션 구현

**커밋:** `ac501b3 feat: WebSocket 실시간 구현`

**사용한 프롬프트:**
> WebSocket 기반 실시간 퀴즈 세션을 구현해줘.
> POST /sessions/start — 세션 생성, 4자리 세션 코드 발급, ws_url 반환.
> WS /sessions/{session_id}/join — JWT 토큰으로 인증. DB 기준으로 강사/학생 역할 자동 결정.
> 연결 시 session_joined 브로드캐스트.
> 강사 이벤트: quiz_start(quiz_id), reveal_answer, end_session.
> 학생 이벤트: submit_answer — answers 테이블에 저장, answer_result 응답.
> ConnectionManager로 세션별 연결 관리.

**생성된 주요 파일:**
- `app/websocket/manager.py` — `ConnectionManager` (connections dict)
- `app/routers/websocket.py`
- `app/routers/sessions.py`
- `app/services/session_service.py` — `create_session`, `submit_answer`, `get_answer_stats`
- `app/models/session.py`

---

## 06. 결과 분석 및 대시보드 구현

**커밋:** `5891320 feat: 결과 분석 및 대시보드 구현`

**사용한 프롬프트:**
> 세션 결과 분석 및 대시보드 API를 구현해줘.
> GET /sessions/{id}/result — Claude API로 학생 오답 패턴 분석, excellent/needs_practice/needs_review 분류.
> GET /dashboard/instructor — 총 세션 수, 평균 정답률, quality_score, 최근 세션 목록.
> GET /dashboard/admin — 플랫폼 전체 통계, 강사별 점수, 위험 학생 목록.
> quality_score 계산: 퀴즈 시행 횟수 40% + 평균 정답률 30% + 세션 완료율 30%.

**생성된 주요 파일:**
- `app/services/analysis_service.py` — `classify_students`, `calculate_instructor_score`
- `app/routers/dashboard.py`
- `app/models/dashboard.py`

---

## 07. Render 배포 설정

**커밋:** `7be65bc feat: 전체 구현 완료 및 Render 배포 설정`

**사용한 프롬프트:**
> Render에 배포하기 위한 설정을 추가해줘.
> render.yaml 또는 start command 설정.
> Python 버전 명시, requirements.txt 정리.

**적용 내용:**
- Render 시작 명령: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- Python 버전 고정 (`4062b8e fix:python version`)

---

## 08. CORS 수정

**커밋:** `9a64e09 fix: CORS 설정 수정 (localhost:3000, vercel 허용)`

**사용한 프롬프트:**
> 프론트에서 CORS 오류가 발생해.
> localhost:3000과 quizai.vercel.app을 허용하도록 CORS 설정 수정해줘.

**적용 내용 (`app/main.py`):**
```python
allow_origins=[
    "http://localhost:3000",
    "https://quizai.vercel.app",
    "https://quizai-fe.vercel.app",
]
```

---

## 09. POST /sessions/join 구현 및 WebSocket CORS 수정

**커밋:** `102ceea feat: POST /sessions/join 구현 및 WebSocket CORS 수정`

**사용한 프롬프트:**
> 학생이 세션 코드로 세션에 참여하는 REST API를 추가해줘.
> POST /sessions/join — session_code, nickname 입력 받아 session_id와 ws_url 반환.
> WebSocket URL도 https 환경에서 wss://로 자동 변환해줘.

**발견된 문제:**
- Render(https) 환경에서 ws:// URL이 생성되어 브라우저가 차단

**적용된 수정:**
- `_build_ws_url()` 헬퍼: `X-Forwarded-Proto` 헤더 기준으로 `wss://` 자동 생성

---

## 10. WebSocket broadcast 버그 수정

**커밋:** `5fbd75c fix: WebSocket broadcast 예외 처리 추가 및 동시 disconnect 방어`

**사용한 프롬프트:**
> WebSocket broadcast 문제를 디버깅해줘.
> 학생은 session_joined 메시지만 받고 이후 아무것도 안 옴.
> 강사가 quiz_start 보내도 학생한테 quiz_started가 브로드캐스트 안 됨.
> broadcast() 함수가 세션 전체에 보내는지 확인하고, 로그로 broadcast 시 몇 명에게 전송했는지 출력해줘.

**발견된 문제:**
- `broadcast()`에서 하나의 소켓 전송 실패 시 예외 처리 없어 루프 중단
- `dict.values()` 직접 순회 → `disconnect` 동시 호출 시 `RuntimeError`

**적용된 수정:**
- `list(items())` 스냅샷으로 순회
- 각 `send_json`을 `try/except`로 감싸기
- `[WS] broadcast | session_id=... | 수신자 수=N / 전체=M` 로그 추가

---

## 11. next_question 이벤트 처리 및 문제 순서 관리

**커밋:** `55e612c fix: WebSocket next_question 이벤트 처리 및 문제 순서 관리 추가`

**사용한 프롬프트:**
> 강사가 보내는 메시지 타입을 수정해줘.
> 현재: "quiz_start" + quiz_id 필요.
> 변경: "next_question" + session_id 로 처리.
> next_question 받으면 세션의 다음 문제를 quizzes 테이블에서 자동으로 찾아서 브로드캐스트.
> 문제 순서는 quizzes 테이블의 questions 배열 인덱스로 관리.
> 세션별 현재 문제 인덱스는 메모리(manager.py)에서 관리.

**적용된 수정:**
- `manager.py`: `question_index` dict 추가, `advance_question()` / `get_current_question_index()` 메서드
- `websocket.py`: `_fetch_question_by_index(index)` 함수로 교체
- payload에 `question_index`, `question_total` 추가

---

## 12. submit_answer selected_option 숫자→문자 변환

**커밋:** `ea95b5a fix: submit_answer selected_option 숫자→문자 변환 및 response_time_ms 선택값 처리`

**사용한 프롬프트:**
> 프론트가 selected_option을 숫자(0=A, 1=B, 2=C, 3=D)로 보내고 있어.
> response_time_ms도 안 보냄.
> websocket.py에서 숫자로 오면 자동으로 문자로 변환해주고,
> response_time_ms 없으면 기본값 0으로 처리해줘.

**발견된 문제:**
- `selected_option = 0` (int)이 오면 `0.upper()` → `AttributeError` 발생
- `except Exception`에 잡혀 `{"type": "error"}` 반환, DB 저장 안 됨

**적용된 수정:**
- `websocket.py`: `_normalize_option(raw)` 헬퍼 — int(0~3) → "A"~"D", str → 대문자
- `session_service.py`: `isinstance(selected_option, int)` 방어 가드 추가

---

## 13. 세션 결과 students 배열 및 대시보드 ended 세션 필터

**커밋:** `9560d05 fix: 세션 결과 students 배열 및 대시보드 ended 세션만 표시`

**사용한 프롬프트:**
> GET /sessions/{id}/result 응답에서 total_students > 0인데 students 배열이 비어있는 문제.
> 응답 형식에 student_id, nickname, score, grade 필드 포함해줘.
> GET /dashboard/instructor에서 waiting 세션은 제외하고 ended 세션만 recent_sessions에 포함해줘.

**발견된 문제:**
- `StudentGrade` 모델에 `nickname`, `score` 필드 없음
- Claude 프롬프트가 한국어 grade 반환 → 프론트 기대값과 불일치
- `recent_sessions[:5]`에 status 필터 없음

**적용된 수정:**
- `StudentGrade`: `student_id`, `nickname`, `score`, `grade` 필드로 재정의
- `SessionResultResponse`: `total_students`, `avg_score` 추가
- Claude 프롬프트 grade 키를 영어로 통일 (`excellent` / `needs_practice` / `needs_review`)
- `classify_students()`: users 테이블에서 nickname 조회, score 직접 계산
- `recent_sessions` 빌드 시 `status == "ended"` 필터 추가

---

## 14. GET /students/me/quiz-results 구현

**커밋:** `602f3f8 feat: GET /students/me/quiz-results 구현`

**사용한 프롬프트:**
> 학생 본인의 퀴즈 결과 목록을 조회하는 API를 구현해줘.
> GET /students/me/quiz-results — 로그인한 학생의 전체 답변 이력 반환.

**생성된 주요 파일:**
- `app/routers/students.py`
- `app/services/student_service.py` — `get_my_quiz_results`
- `app/models/student.py` — `QuizResult`, `QuizResultList`

---

## 15. answers 저장 실패 디버깅 및 로그 추가

**커밋:** `a0bd843 fix: answers 저장 실패 시 500 에러 반환 및 로그 추가`

**사용한 프롬프트:**
> Render 로그에 [answer] saved 로그가 없어.
> 학생이 답변 제출해도 answers 테이블에 저장이 안 되는 것 같아.
> Supabase answers 테이블 RLS 확인 SQL과 비활성화 SQL 만들어줘.
> POST /sessions/{id}/answer로 답변 제출 시 answers 테이블에 실제로 데이터가 저장되는지 확인해줘.

**발견된 문제:**
- `supabase.table("answers").insert(...).execute()` 결과를 변수에 저장하지 않아 silent fail 가능
- RLS 정책으로 insert 차단 시 예외 없이 빈 data 반환

**적용된 수정:**
- `insert_result` 변수에 저장 후 `insert_result.data` 비어있으면 500 에러 발생
- `[answer] saved` / `[answer] insert 실패` 로그 추가
- `_fetch_session_data()`에 `[classify] answers 조회 | 총 답변 수=N` 로그 추가

**RLS 비활성화 SQL (Supabase SQL Editor에서 실행):**
```sql
ALTER TABLE answers  DISABLE ROW LEVEL SECURITY;
ALTER TABLE sessions DISABLE ROW LEVEL SECURITY;
ALTER TABLE users    DISABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes  DISABLE ROW LEVEL SECURITY;
```

---

## 16. 학생별 문항 정오답 배열 추가

**커밋:** `d8e4391 feat: 세션 결과에 학생별 문항 정오답 배열 추가`

**사용한 프롬프트:**
> GET /sessions/{id}/result 응답에 학생별 문항 정오답 배열 추가해줘.
> 각 학생 객체에 answers 배열 포함.
> selected_option은 문자("A","B","C","D")를 숫자(0,1,2,3)로 변환해서 반환.

**적용된 수정:**
- `analysis_service.py`: `_OPTION_TO_INDEX` 상수 추가
- `_aggregate_by_student()`: 각 학생에 `answers` 배열 포함 (selected_option 문자→숫자 변환)
- `classify_students()`: `answers_map` 빌드 후 학생 객체에 합산
- `models/dashboard.py`: `StudentAnswer` 모델 신설, `StudentGrade`에 `answers: list[StudentAnswer] = []` 추가

---

## 작성 규칙

새 작업을 완료할 때마다 아래 형식으로 맨 아래에 항목을 추가합니다:

```markdown
## NN. 작업 제목

**커밋:** `커밋해시 커밋메시지`

**사용한 프롬프트:**
> 실제로 Claude Code에 입력한 프롬프트 내용

**발견된 문제:** (버그 수정인 경우)
- 문제 내용

**적용된 수정:**
- 수정 내용 요약
```

- 번호는 순서대로 증가 (NN 형식, 01부터 시작)
- 프롬프트는 실제 입력 내용을 최대한 그대로 기록
- 커밋 해시는 `git log --oneline`으로 확인
- 기능 구현과 버그 수정 모두 기록
