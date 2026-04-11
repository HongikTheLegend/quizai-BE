-- ============================================================
-- QuizAI 더미 데이터
-- 비밀번호: test1234 (bcrypt)
-- 실행 순서: 삭제(역방향 FK) → 삽입
-- ============================================================

-- ──────────────────────────────────────────────
-- 1. 기존 데이터 삭제 (FK 역순)
-- ──────────────────────────────────────────────
DELETE FROM answers;
DELETE FROM sessions;
DELETE FROM quizzes;
DELETE FROM lectures;
DELETE FROM users;

-- ──────────────────────────────────────────────
-- 2. users (강사 4명 + 수강생 20명 + 운영자 3명)
-- ──────────────────────────────────────────────
INSERT INTO users (id, email, password_hash, name, role) VALUES

-- 강사
('0e0e513c-cb88-4aa4-bcc0-488d3435d0f3', 'instructor1@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '김민준', 'instructor'),
('b622adcc-b247-45b5-9e4c-980948190423', 'instructor2@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '이수진', 'instructor'),
('06a766d1-8e82-4631-89bd-68a956d6fb26', 'instructor3@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '박지호', 'instructor'),
('f73909bc-da9e-4a8f-ab21-b4fe6a097c10', 'instructor4@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '최유리', 'instructor'),

-- 수강생
('7714e381-4cd3-4e9c-8368-3ab57ed436de', 'student1@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생1',  'student'),
('5398f3a5-36f5-4643-b44c-04c2a3cd542c', 'student2@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생2',  'student'),
('c77287ad-4858-40b5-ae47-07d481b5ba28', 'student3@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생3',  'student'),
('f379cc84-5936-4511-b61d-75a947929d84', 'student4@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생4',  'student'),
('a7696bd1-9fd8-43af-b580-a164733a65dc', 'student5@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생5',  'student'),
('cef3fb12-74ee-4d2d-8d5d-146e87d83b48', 'student6@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생6',  'student'),
('e37ffc43-82de-4d9e-a143-2ad548cb6f2d', 'student7@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생7',  'student'),
('b2ed5cb9-0e31-4929-9774-d1dc3be100a1', 'student8@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생8',  'student'),
('744d8720-213d-4a28-bac2-4099cc9cb046', 'student9@test.com',  '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생9',  'student'),
('14ca14a5-a14f-44b3-a508-23b39b44d3c5', 'student10@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생10', 'student'),
('f4c6b14f-6517-499f-8694-0b86ccc547a0', 'student11@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생11', 'student'),
('5bb9fb6a-586c-40ad-b63b-d224318a3f33', 'student12@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생12', 'student'),
('3558b5e4-d8cf-4f8e-9fdc-e03d06ea9687', 'student13@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생13', 'student'),
('52b9459f-ecb4-4e82-bc40-109ede361ab9', 'student14@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생14', 'student'),
('b22cc175-6817-4e93-b302-ab8ca87bc6f7', 'student15@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생15', 'student'),
('cb880339-8370-4957-810d-ea20d3a0e355', 'student16@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생16', 'student'),
('3a42d9ec-b574-47a8-8c53-0299dcec337a', 'student17@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생17', 'student'),
('7dd36739-30e4-4706-a32f-10f93d060fd4', 'student18@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생18', 'student'),
('36d10a08-0019-4af5-9e79-959996e0405b', 'student19@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생19', 'student'),
('1f8d4374-6b8b-417b-992a-ac57ad4a08f4', 'student20@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '학생20', 'student'),

-- 운영자
('c4b73ea7-4fc4-4144-b223-a907421efc90', 'admin1@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자1', 'admin'),
('74b15af3-0e8c-4ef6-84a8-3c85d21ab74d', 'admin2@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자2', 'admin'),
('075fa6e1-9aba-4ea8-bd40-1dec4026dc47', 'admin3@test.com', '$2b$12$hxDBI6tfE0FvxpdcdmdfMeYFfjWxz.SZCVFvts16mOkBfsDuvJvC.', '운영자3', 'admin');

-- ──────────────────────────────────────────────
-- 3. lectures (강사별 2~3개, 총 10개)
-- ──────────────────────────────────────────────
INSERT INTO lectures (id, instructor_id, title, content, text_length) VALUES

-- 김민준 (instructor1) - 3개
('2da6832d-26a1-4679-8010-8edebdcf5414', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '머신러닝 기초',
 '머신러닝은 데이터로부터 패턴을 학습하여 예측하는 기술입니다. 지도학습, 비지도학습, 강화학습으로 구분됩니다. 지도학습은 레이블이 있는 데이터로 분류와 회귀 문제를 풀고, 비지도학습은 레이블 없이 클러스터링과 차원축소를 수행합니다. 대표 알고리즘으로는 선형회귀, 결정트리, 랜덤포레스트, SVM 등이 있습니다.',
 200),
('29e12500-f8bc-44f3-8ad9-9355508df8ce', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '딥러닝 심화',
 '딥러닝은 다층 신경망을 이용하여 복잡한 패턴을 학습합니다. CNN은 이미지 분류에, RNN은 시퀀스 데이터에, Transformer는 자연어 처리에 주로 사용됩니다. 역전파 알고리즘과 경사하강법을 통해 가중치를 업데이트하며, 드롭아웃과 배치 정규화로 과적합을 방지합니다.',
 200),
('4caf0a17-4307-47d6-b84d-00a7826072db', '0e0e513c-cb88-4aa4-bcc0-488d3435d0f3',
 '자연어 처리 입문',
 '자연어 처리(NLP)는 컴퓨터가 인간의 언어를 이해하고 생성하는 기술입니다. 토큰화, 형태소 분석, 품사 태깅, 개체명 인식 등의 전처리 과정을 거칩니다. Word2Vec, BERT, GPT 등 임베딩 모델이 발전하면서 문맥 이해 능력이 크게 향상되었습니다.',
 200),

-- 이수진 (instructor2) - 3개
('1efbab46-3ad9-498d-9aa5-bf1b4235a52f', 'b622adcc-b247-45b5-9e4c-980948190423',
 'Python 입문',
 'Python은 간결한 문법과 풍부한 라이브러리로 초보자에게 적합한 언어입니다. 변수, 조건문, 반복문, 함수, 클래스 등의 기본 문법을 배웁니다. list, dict, tuple, set 등의 자료구조와 파일 입출력, 예외 처리도 핵심 개념입니다.',
 200),
('f497b12b-169d-4ec5-a275-a834430ca009', 'b622adcc-b247-45b5-9e4c-980948190423',
 '데이터 분석 with Pandas',
 'Pandas는 Python에서 데이터 분석을 위한 핵심 라이브러리입니다. DataFrame과 Series를 이용하여 데이터를 로드, 탐색, 정제합니다. groupby, merge, pivot_table 등으로 데이터를 집계하고, matplotlib/seaborn과 연계하여 시각화합니다.',
 200),
('3c74645c-fa62-45b7-8c32-aa2f7a6a2397', 'b622adcc-b247-45b5-9e4c-980948190423',
 '웹 개발 기초 (FastAPI)',
 'FastAPI는 Python 기반의 고성능 웹 프레임워크로 자동 문서화를 지원합니다. Path/Query/Body 파라미터, Pydantic 모델, 의존성 주입, JWT 인증을 활용합니다. 비동기(async/await)를 기본으로 지원하여 높은 처리량을 달성합니다.',
 200),

-- 박지호 (instructor3) - 2개
('dcc6dfbe-238b-48b0-80ba-0aa39d86c638', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '데이터베이스 설계',
 '관계형 데이터베이스는 테이블 간 관계를 외래키로 표현합니다. 정규화(1NF~3NF)를 통해 데이터 중복을 제거하고 무결성을 보장합니다. 인덱스는 검색 성능을 향상시키며, 트랜잭션은 ACID 속성으로 데이터 일관성을 유지합니다.',
 200),
('14670c51-57c1-4c0a-bb60-d7a482aca7e3', '06a766d1-8e82-4631-89bd-68a956d6fb26',
 '클라우드 컴퓨팅 개론',
 '클라우드 컴퓨팅은 IaaS, PaaS, SaaS로 구분됩니다. AWS, GCP, Azure가 주요 공급자이며 가상화 기술로 자원을 탄력적으로 제공합니다. 컨테이너(Docker)와 오케스트레이션(Kubernetes)이 현대 클라우드의 핵심 기술입니다.',
 200),

-- 최유리 (instructor4) - 2개
('e23d5ac7-b7bc-4bb2-b50a-ad652d509d92', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '알고리즘과 자료구조',
 '자료구조는 데이터를 효율적으로 저장하고 접근하는 방식입니다. 배열, 연결리스트, 스택, 큐, 트리, 그래프, 해시테이블을 학습합니다. 알고리즘의 시간복잡도는 Big-O 표기법으로 나타내며, 정렬·탐색·동적프로그래밍이 핵심 유형입니다.',
 200),
('8d1b526b-80d7-4d2e-8b56-71742e48d41e', 'f73909bc-da9e-4a8f-ab21-b4fe6a097c10',
 '컴퓨터 네트워크',
 '네트워크는 OSI 7계층 모델로 구조화됩니다. TCP/IP 프로토콜이 인터넷의 근간이며, HTTP/HTTPS는 웹 통신에 사용됩니다. DNS, DHCP, NAT, 방화벽 등 핵심 구성 요소와 소켓 프로그래밍 기초를 다룹니다.',
 200);
