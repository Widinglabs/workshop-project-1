# Claude Code Configuration

This directory contains the AI layer for the workshop project — the infrastructure that makes Claude Code trustworthy and consistent across your team.

## Directory Structure

```
.claude/
├── skills/          # Reusable slash commands (invoke with /ws-*)
├── rules/           # Path-scoped rules (loaded on-demand per file type)
├── hooks/           # Shell scripts that run at lifecycle events
└── artifacts/       # Generated output from skills (plans, reports, reviews)
```

## Skills (`/ws-*` commands)

Custom slash commands that encode repeatable workflows. Each skill is a directory with a `SKILL.md` entrypoint.

| Command | Purpose |
|---------|---------|
| `/ws-prime` | Load full codebase context into the agent |
| `/ws-plan-feature` | Analyze codebase and generate an implementation plan |
| `/ws-implement` | Execute a plan with validation after each step |
| `/ws-validate` | Run lint, type-check, and tests across the stack |
| `/ws-review` | Code review with severity ratings |
| `/ws-install` | Set up dependencies and start servers |

These follow the **PIV Loop**: Plan → Implement → Validate.

## Rules (path-scoped)

Rules load on-demand when Claude reads matching files. Right context at the right time.

| Rule | Loaded for | Purpose |
|------|-----------|---------|
| `backend.md` | `app/backend/**/*.py` | Python/FastAPI conventions |
| `frontend.md` | `app/frontend/**/*.{ts,tsx}` | React/TypeScript conventions |
| `testing.md` | `app/backend/tests/**/*.py` | Test naming and structure |

## Hooks (automated guardrails)

Shell commands that fire at lifecycle events. Deterministic — always run, can't be ignored by the LLM.

| Hook | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse | Blocks `rm -rf /`, `DROP TABLE`, force push, commits on main |
| `guard-files.sh` | PreToolUse | Blocks writes to `.env`, credentials, private keys |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

## Built-in Commands Worth Knowing

Claude Code ships with built-in skills alongside our custom `/ws-*` ones:

| Command | Purpose |
|---------|---------|
| `/simplify` | Spawns 3 parallel agents to review changed code for reuse, quality, and efficiency — then fixes issues |
| `/batch` | Decomposes large-scale changes into parallel units, each running in an isolated worktree |
| `/init` | Auto-generates a starting CLAUDE.md from your codebase |
| `/memory` | View and manage auto-memory and loaded rules |
| `/debug` | Troubleshoot your Claude Code session |

## How It All Fits Together

1. **CLAUDE.md** (project root) — always loaded, sets project-wide standards
2. **Rules** — loaded on-demand when working in specific parts of the codebase
3. **Skills** — invoked explicitly to run structured workflows
4. **Hooks** — enforce guardrails automatically, no prompting needed

The agent sees CLAUDE.md every session. Rules activate as it reads files. Skills give it playbooks. Hooks keep it safe. Together, they replace "hoping the AI does the right thing" with infrastructure that guarantees it.
