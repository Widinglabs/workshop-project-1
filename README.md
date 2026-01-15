# Exercise 3: PIV Loop Practice

Practice the **PIV Loop** methodology with your own feature ideas.

This exercise has the same codebase and commands as Exercise 2, but no predefined tasks.

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

| Artifact | Path |
|----------|------|
| Plans | `.{tool}/artifacts/plans/` |
| Reports | `.{tool}/artifacts/reports/` |
| Reviews | `.{tool}/artifacts/reviews/` |

## Quick Start

Run `/install` or manually:

**Backend**: `cd app/backend && uv venv --python 3.12 && uv sync && uv run python run_api.py`

**Frontend**: `cd app/frontend && bun install && bun dev`

## Suggested Features

Ideas to practice the PIV loop:

- Add pagination to product list
- Add product sorting UI
- Add "out of stock" visual indicator
- Add product count display
- Add price range filter
- Add category badges to products

## Workflow

1. **Plan**: `/plan "your feature description"`
2. **Implement**: `/implement path/to/plan.md`
3. **Validate**: `/validate`
4. **Review**: `/review all`
