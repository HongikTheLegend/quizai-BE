# BACKEND_HANDOFF.md — 프론트엔드 연동 스펙

## Base URL

| 환경 | URL |
|------|-----|
| 로컬 | `http://localhost:8000` |
| 배포 | `https://quizai-api.onrender.com` |

API 문서(Swagger): `{BASE_URL}/docs`

---

## 인증

모든 보호된 엔드포인트는 요청 헤더에 JWT 토큰 필요:

```
Authorization: Bearer <access_token>
```

토큰은 로그인/회원가입 응답의 `access_token` 필드에서 획득.

---

## REST API 엔드포인트

### Auth

#### POST /auth/register
회원가입

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "홍길동",
  "role": "instructor"
}
```
`role`: `"instructor"` | `"student"`

**Response 201:**
```json
{
  "access_token": "eyJ...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "홍길동",
    "role": "instructor"
  }
}
```

---

#### POST /auth/login
로그인

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response 200:** (register와 동일 형식)

---

#### GET /auth/me
현재 로그인 사용자 정보 조회 `[인증 필요]`

**Response 200:**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "홍길동",
  "role": "instructor"
}
```

---

### Lectures

#### POST /lectures/upload
강의록 업로드 `[인증 필요, 강사]`

**Content-Type:** `multipart/form-data`

| 필드 | 타입 | 설명 |
|------|------|------|
| `file` | File | PDF, TXT, DOCX (최대 10MB) |
| `title` | string | 강의 제목 |

**Response 201:**
```json
{
  "lecture_id": "uuid",
  "title": "운영체제 1강",
  "text_length": 4821,
  "created_at": "2026-04-12T10:00:00"
}
```

---

#### GET /lectures
내 강의 목록 조회 `[인증 필요, 강사]`

**Response 200:**
```json
[
  {
    "id": "uuid",
    "title": "운영체제 1강",
    "instructor_id": "uuid",
    "text_length": 4821,
    "created_at": "2026-04-12T10:00:00"
  }
]
```

---

### Quizzes

#### POST /quizzes/generate
퀴즈 생성 `[인증 필요, 강사]`

**Request Body:**
```json
{
  "lecture_id": "uuid",
  "count": 5,
  "quiz_type": "multiple_choice"
}
```

**Response 200:**
```json
{
  "quiz_set_id": "uuid",
  "quizzes": [
    {
      "id": "uuid",
      "question": "운영체제의 역할은?",
      "options": [
        {"label": "A", "text": "하드웨어 관리"},
        {"label": "B", "text": "네트워크 관리"},
        {"label": "C", "text": "데이터베이스 관리"},
        {"label": "D", "text": "UI 렌더링"}
      ],
      "answer": "A",
      "explanation": "운영체제는 하드웨어 자원을 관리합니다."
    }
  ]
}
```

---

#### GET /quizzes/{lecture_id}
강의별 퀴즈 목록 조회 `[인증 필요]`

**Response 200:** (배열 형식, quizzes/generate 응답의 quizzes와 동일 구조)

---

### Sessions

#### POST /sessions/start
세션 시작 `[인증 필요, 강사]`

**Request Body:**
```json
{
  "quiz_set_id": "uuid",
  "time_limit": 30
}
```
`time_limit`: 문항당 제한 시간(초)

**Response 200:**
```json
{
  "session_id": "uuid",
  "session_code": "AB12",
  "ws_url": "wss://quizai-api.onrender.com/sessions/{session_id}/join",
  "status": "waiting"
}
```

---

#### POST /sessions/join
세션 참여 (코드 입력)

**Request Body:**
```json
{
  "session_code": "AB12",
  "nickname": "학생1"
}
```

**Response 200:**
```json
{
  "session_id": "uuid",
  "ws_url": "wss://quizai-api.onrender.com/sessions/{session_id}/join"
}
```

---

#### POST /sessions/{session_id}/answer
REST 방식 답변 제출 `[인증 필요, 학생]`

**Request Body:**
```json
{
  "quiz_id": "uuid",
  "selected_option": "A",
  "response_time_ms": 3500
}
```

**Response 200:**
```json
{
  "is_correct": true,
  "correct_option": "A",
  "explanation": "운영체제는 하드웨어 자원을 관리합니다."
}
```

---

#### GET /sessions/{session_id}/result
세션 결과 조회 `[인증 필요]`
- 강사: 본인 세션만
- 학생: 참여한 세션만
- admin: 전체

**Response 200:**
```json
{
  "session_id": "uuid",
  "total_students": 10,
  "avg_score": 68.5,
  "grade_distribution": {
    "excellent": 3,
    "needs_practice": 4,
    "needs_review": 3
  },
  "weak_concepts": ["프로세스 스케줄링", "메모리 관리"],
  "students": [
    {
      "student_id": "uuid",
      "nickname": "학생1",
      "score": 80.0,
      "grade": "excellent",
      "answers": [
        {
          "quiz_id": "uuid",
          "selected_option": 0,
          "is_correct": true
        }
      ]
    }
  ]
}
```
`grade`: `"excellent"` | `"needs_practice"` | `"needs_review"`
`answers[].selected_option`: 0=A, 1=B, 2=C, 3=D

---

### Dashboard

#### GET /dashboard/instructor
강사 대시보드 `[인증 필요, 강사/admin]`

**Response 200:**
```json
{
  "total_sessions": 12,
  "avg_participation_rate": 18.3,
  "avg_correct_rate": 72.1,
  "quality_score": 85.5,
  "recent_sessions": [
    {
      "session_id": "uuid",
      "session_code": "AB12",
      "status": "ended",
      "created_at": "2026-04-12T10:00:00",
      "participant_count": 20,
      "correct_rate": 68.5
    }
  ]
}
```
`recent_sessions`: `ended` 상태 세션만 최근 5개

---

#### GET /dashboard/admin
관리자 대시보드 `[인증 필요, admin]`

**Response 200:**
```json
{
  "platform": {
    "total_users": 150,
    "total_sessions": 40,
    "total_answers": 1200,
    "avg_correct_rate": 65.3
  },
  "instructors": [
    {
      "instructor_id": "uuid",
      "name": "김교수",
      "email": "prof@example.com",
      "total_sessions": 10,
      "quality_score": 88.0
    }
  ],
  "at_risk_students": [
    {
      "user_id": "uuid",
      "name": "홍길동",
      "email": "student@example.com",
      "overall_correct_rate": 32.5,
      "total_answers": 15
    }
  ]
}
```

---

### Students

#### GET /students/me/quiz-results
내 퀴즈 결과 목록 `[인증 필요, 학생]`

**Response 200:**
```json
{
  "results": [
    {
      "session_id": "uuid",
      "quiz_id": "uuid",
      "is_correct": true,
      "selected_option": "A",
      "correct_option": "A",
      "response_time_ms": 3500,
      "created_at": "2026-04-12T10:00:00"
    }
  ]
}
```

---

## WebSocket

### 연결

```
ws://localhost:8000/sessions/{session_id}/join?token=<JWT>&nickname=<닉네임>
wss://quizai-api.onrender.com/sessions/{session_id}/join?token=<JWT>&nickname=<닉네임>
```

- `token`: JWT 액세스 토큰 (query parameter)
- `nickname`: 표시 이름 (학생만 의미 있음)
- 연결 후 역할(instructor/student)은 DB의 `sessions.instructor_id`로 자동 결정

### 서버 → 클라이언트 이벤트

| type | 발생 시점 | 데이터 |
|------|-----------|--------|
| `session_joined` | 누군가 세션에 연결될 때 (본인 포함) | `user_id`, `nickname`, `role`, `participant_count` |
| `quiz_started` | 강사가 next_question 보낼 때 | `payload`: `{quiz_id, question_index, question_total, question, options, time_limit}` |
| `answer_revealed` | 강사가 정답 공개할 때 | `quiz_id` |
| `answer_update` | 학생이 답변 제출할 때 (강사에게만) | `quiz_id`, `answer_count`, `response_rate` |
| `answer_result` | 내가 답변 제출했을 때 (본인에게만) | `is_correct`, `correct_option`, `explanation` |
| `session_ended` | 강사가 세션 종료할 때 | (없음) |
| `session_left` | 누군가 연결을 끊을 때 | `user_id`, `nickname`, `participant_count` |
| `error` | 처리 중 오류 발생 시 | `detail` |

### 클라이언트 → 서버 이벤트

#### 강사가 보내는 이벤트

**next_question** — 다음 문제 출제
```json
{ "type": "next_question" }
```

**reveal_answer** — 정답 공개
```json
{
  "type": "reveal_answer",
  "quiz_id": "uuid"
}
```

**end_session** — 세션 종료
```json
{ "type": "end_session" }
```

#### 학생이 보내는 이벤트

**submit_answer** — 답변 제출
```json
{
  "type": "submit_answer",
  "quiz_id": "uuid",
  "selected_option": 0,
  "response_time_ms": 3500
}
```
- `selected_option`: 숫자 인덱스 (0=A, 1=B, 2=C, 3=D)
- `response_time_ms`: 생략 시 0으로 처리

---

## 환경변수

`.env.example` 참고:

| 변수명 | 설명 | 예시 |
|--------|------|------|
| `ANTHROPIC_API_KEY` | Claude API 키 | `sk-ant-...` |
| `SUPABASE_URL` | Supabase 프로젝트 URL | `https://xxx.supabase.co` |
| `SUPABASE_KEY` | Supabase service role key (RLS 우회용) | `eyJ...` |
| `JWT_SECRET` | JWT 서명 시크릿 | 랜덤 문자열 32자 이상 |
| `FRONTEND_URL` | CORS 허용 프론트 URL | `https://quizai.vercel.app` |

> Supabase key는 **service role key** 사용 권장 (anon key 사용 시 RLS 정책 별도 설정 필요)

---

## 에러 코드

| HTTP 코드 | 상황 |
|-----------|------|
| 401 | 토큰 없음 / 만료 / 잘못된 자격증명 |
| 403 | 권한 없음 (역할 불일치, 타인 세션 접근 등) |
| 404 | 리소스 없음 |
| 409 | 중복 (이미 답변 제출, 이메일 중복 등) |
| 500 | 서버 내부 오류 (DB 저장 실패 등) |

WebSocket 연결 실패 코드:

| 코드 | 상황 |
|------|------|
| 4001 | 인증 실패 (토큰 없음/만료) |
| 4004 | 세션 없음 |
