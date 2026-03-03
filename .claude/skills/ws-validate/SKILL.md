---
description: Run linter, type checker, and tests - report any failures
---

# Validate

Run all validation checks and report results.

---

## Checks to Run

### Backend (app/backend)

```bash
cd app/backend

# Lint and format check
uv run ruff check .
uv run ruff format --check .

# Run all tests
uv run pytest tests/ -v
```

### Frontend (app/frontend)

```bash
cd app/frontend

# Lint and type check
bun run check
```

---

## Process

1. Run backend checks, capture output
2. Run frontend checks, capture output
3. Collect all failures
4. Report results

---

## Output

Report in this format:

```
## Validation Results

### Backend
| Check | Result | Details |
|-------|--------|---------|
| Ruff lint | ✅/❌ | {N errors or "passed"} |
| Ruff format | ✅/❌ | {N files or "passed"} |
| Tests | ✅/❌ | {N passed, M failed} |

### Frontend
| Check | Result | Details |
|-------|--------|---------|
| Biome check | ✅/❌ | {N errors or "passed"} |

### Summary
- **Status**: ✅ ALL PASSING / ❌ {N} FAILURES
- **Action needed**: {None / list of things to fix}
```

---

## If Failures Found

List each failure with:
1. File and line number
2. Error message
3. Suggested fix (if obvious)

Example:
```
### Failures

1. **app/backend/app/services/products.py:42**
   - Error: `ruff: E501 line too long`
   - Fix: Break line or run `uv run ruff format .`

2. **app/frontend/src/App.tsx:15**
   - Error: `lint: unused variable 'x'`
   - Fix: Remove unused variable or prefix with `_`
```
