---
paths:
  - "app/backend/**/*.py"
---

# Backend Rules

- Use `Decimal` for prices, never `float`
- Use `Literal` types for constrained string fields (e.g. categories)
- Route handlers delegate to services — no business logic in `app/api/`
- All models use Pydantic with `Field` validators
- Structured logging: `logger.info("action_name", key=value)`
- Lint with `uv run ruff check .` and format with `uv run ruff format .`
- Run tests with `uv run pytest tests/ -v`
