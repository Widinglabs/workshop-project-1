# Exercise 2: PIV Loop Implementation

Apply the **PIV Loop** methodology: **P**lanning → **I**mplementing → **V**alidating

Same task as Exercise 1, but with structured planning and reusable prompts.

## Using Reusable Prompts

| Tool | Location | Invocation |
|------|----------|------------|
| Claude Code | `.claude/commands/` | `/project:command-name` |
| Cursor | `.cursor/commands/` | `/command-name` |
| VS Code Copilot | `.github/prompts/` | `#prompt-name` |

## Quick Start

**Backend** (Terminal 1):
```bash
cd app/backend && uv venv --python 3.12 && uv sync && uv run python run_api.py
```

**Frontend** (Terminal 2):
```bash
cd app/frontend && bun install && bun dev
```

## The Task

1. **Plan**: Read `tasks/TASK1.md` (backend) and `tasks/TASK2.md` (frontend), then create an implementation plan
2. **Implement**: Use your plan as context when prompting your AI assistant
3. **Validate**: Run tests with `cd app/backend && uv run pytest tests/ -v`

## Success Criteria

- All backend tests pass
- Frontend displays working filter UI
- Filters work together (price, category, search, sort)
