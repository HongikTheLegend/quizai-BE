-- ============================================================
-- sessions 테이블
-- ============================================================
CREATE TABLE sessions (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_set_id     UUID        NOT NULL,           -- quizzes.id 참조
    instructor_id   UUID        NOT NULL,           -- users.id 참조
    session_code    CHAR(4)     NOT NULL UNIQUE,    -- 학생 입장용 4자리 코드
    time_limit      INTEGER     NOT NULL,           -- 제한 시간 (초)
    status          TEXT        NOT NULL DEFAULT 'waiting',  -- waiting | active | ended
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 빠른 코드 조회를 위한 인덱스
CREATE INDEX idx_sessions_code ON sessions (session_code);
CREATE INDEX idx_sessions_instructor ON sessions (instructor_id);

-- ============================================================
-- answers 테이블
-- ============================================================
CREATE TABLE answers (
    id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id       UUID        NOT NULL REFERENCES sessions (id) ON DELETE CASCADE,
    quiz_id          TEXT        NOT NULL,   -- quizzes.questions[].id (JSONB 내부 UUID)
    user_id          UUID        NOT NULL,   -- users.id 참조
    selected_option  TEXT        NOT NULL,   -- A | B | C | D
    is_correct       BOOLEAN     NOT NULL,
    response_time_ms INTEGER     NOT NULL,
    submitted_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- 동일 세션·문제·사용자 중복 제출 방지
    UNIQUE (session_id, quiz_id, user_id)
);

CREATE INDEX idx_answers_session_quiz ON answers (session_id, quiz_id);
CREATE INDEX idx_answers_user ON answers (user_id);
