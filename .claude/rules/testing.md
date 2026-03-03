---
paths:
  - "app/backend/tests/**/*.py"
---

# Testing Rules

- Use pytest with `-v` flag for verbose output
- Shared fixtures go in `conftest.py`
- Test file naming: `test_<feature>.py`
- Test function naming: `test_<what>_<condition>_<expected>`
- Run filtering tests: `uv run pytest tests/test_products_filtering.py -v`
