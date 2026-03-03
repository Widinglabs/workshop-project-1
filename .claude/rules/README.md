# Claude Code Rules

Path-scoped rules that load on-demand when Claude reads matching files.

## How It Works

Each `.md` file here can have a `paths` frontmatter field with glob patterns. Rules without `paths` load at launch. Rules with `paths` load only when Claude reads files matching those patterns.

## Files

| Rule | Scoped To | Purpose |
|------|-----------|---------|
| `backend.md` | `app/backend/**/*.py` | Python/FastAPI conventions |
| `frontend.md` | `app/frontend/**/*.{ts,tsx}` | React/TypeScript conventions |
| `testing.md` | `app/backend/tests/**/*.py` | Test naming and structure |

## Adding Rules

Create a new `.md` file with optional path scoping:

```markdown
---
paths:
  - "path/to/match/**/*.ext"
---

# Rule Title

- Your rules here
```
