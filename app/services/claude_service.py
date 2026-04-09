import json
import logging

from anthropic import APIError

from app.core.config import settings

logger = logging.getLogger(__name__)

_client = None


def _get_client():
    global _client
    if _client is None:
        import anthropic
        _client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    return _client


def _build_prompt(text: str, count: int) -> str:
    return (
        f"다음 강의록을 분석해서 객관식 4지선다 퀴즈 {count}개를 만들어줘.\n"
        "반드시 아래 JSON 형식으로만 응답해. 다른 텍스트 없이 JSON만:\n"
        '[{"question": "질문", "options": ["보기1", "보기2", "보기3", "보기4"], '
        '"answer": 0, "explanation": "해설"}]\n\n'
        f"강의록:\n{text}"
    )


def _parse_response(content: str) -> list[dict]:
    content = content.strip()
    # JSON 블록만 추출
    if "```" in content:
        start = content.find("[", content.find("```"))
        end = content.rfind("]") + 1
    else:
        start = content.find("[")
        end = content.rfind("]") + 1

    if start == -1 or end == 0:
        raise ValueError("JSON 배열을 찾을 수 없습니다")

    return json.loads(content[start:end])


def _call_api(text: str, count: int) -> list[dict]:
    client = _get_client()
    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=4096,
        messages=[{"role": "user", "content": _build_prompt(text, count)}],
    )
    raw = response.content[0].text
    return _parse_response(raw)


async def generate_quizzes(text: str, count: int = 5) -> list[dict]:
    """
    강의록 텍스트로 퀴즈를 생성합니다.
    반환: [{"question", "options": [4개], "answer": 0-based int, "explanation"}]
    실패 시 1회 재시도.
    """
    try:
        return _call_api(text, count)
    except (APIError, ValueError, json.JSONDecodeError) as e:
        logger.warning("Claude API 첫 번째 시도 실패, 재시도 중: %s", e)
        return _call_api(text, count)
