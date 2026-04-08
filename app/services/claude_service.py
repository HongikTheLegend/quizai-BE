import anthropic

from app.core.config import settings

_client: anthropic.Anthropic | None = None


def get_claude_client() -> anthropic.Anthropic:
    global _client
    if _client is None:
        _client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    return _client
