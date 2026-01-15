# Exercise 2: PIV Loop Implementation

Apply the **PIV Loop** methodology: **P**lanning → **I**mplementing → **V**alidating

Same task as Exercise 1, but with structured planning and reusable prompts.

## Commands

### PIV Loop Commands

| Command | Description |
|---------|-------------|
| `/plan` | Create implementation plan through codebase analysis |
| `/implement` | Execute a plan with validation loops |
| `/validate` | Run linter, type checker, and tests |
| `/review` | Code review with issue categorization |

### Utility Commands

| Command | Description |
|---------|-------------|
| `/install` | Install dependencies and start servers |
| `/prime` | Prime agent with codebase understanding |

### Command Locations

| Tool | Location | Invocation |
|------|----------|------------|
| Claude Code | `.claude/commands/` | `/command-name` |
| Cursor | `.cursor/commands/` | `/command-name` |
| VS Code Copilot | `.github/prompts/` | `#prompt-name` |

### Artifacts

Commands generate artifacts in tool-specific directories:

| Artifact | Path |
|----------|------|
| Plans | `.{tool}/artifacts/plans/` |
| Reports | `.{tool}/artifacts/reports/` |
| Reviews | `.{tool}/artifacts/reviews/` |

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

1. **Plan**: Read `tasks/TASK1.md` (backend) and `tasks/TASK2.md` (frontend), then run `/plan`
2. **Implement**: Run `/implement` with your plan
3. **Validate**: Run `/validate` to verify everything works

## Success Criteria

- All backend tests pass
- Frontend displays working filter UI
- Filters work together (price, category, search, sort)
