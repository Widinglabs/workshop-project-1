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

## Advanced Features

### Agent Teams (Experimental)

Multiple Claude Code instances collaborating on a shared project. One session acts as the "team lead" that spawns "teammates" — each with their own context window.

```bash
# Enable in settings.json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```

Teammates coordinate through a shared task list and direct messaging. Good for parallel code review (3 reviewers on different aspects), competing debug hypotheses, or splitting a feature across backend/frontend/tests.

### Worktrees — Parallel Isolated Sessions

Each agent gets its own copy of the repo via git worktrees. No file conflicts, no branch collisions.

```bash
claude --worktree feature-auth    # Creates .claude/worktrees/feature-auth/
claude -w bugfix-123              # Separate branch, separate files
```

Run 3-5 agents simultaneously on different tasks. Worktrees share project config (skills, hooks, rules) but have isolated file and git state. Clean up is automatic when there are no changes.

### Headless Mode — Scripts and CI/CD

Run Claude non-interactively for automation:

```bash
claude -p "Find and fix the bug in auth.py"                    # One-shot
claude -p "Review this PR" --output-format json                # Structured output
claude -p "Extract function names" --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}}}'
```

Powers GitHub Actions (`@claude` mentions in PRs) and CI/CD pipelines.

### Remote Control

Start Claude locally, continue from any browser or phone. Computation stays on your machine — the web UI is just a remote display.

```bash
claude remote-control    # Generates URL + QR code
/remote-control          # Enable from existing session
```

Requires Max plan. Great for long-running tasks — fire it off and check from your phone.

### Agent SDK

Programmatic control from Python or TypeScript:

```python
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Find and fix the bug in auth.py",
    options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"]),
):
    print(message.result)
```

Full access to tools, sessions, hooks, and streaming. The foundation for custom AI workflows.

## How It All Fits Together

1. **CLAUDE.md** (project root) — always loaded, sets project-wide standards
2. **Rules** — loaded on-demand when working in specific parts of the codebase
3. **Skills** — invoked explicitly to run structured workflows
4. **Hooks** — enforce guardrails automatically, no prompting needed

The agent sees CLAUDE.md every session. Rules activate as it reads files. Skills give it playbooks. Hooks keep it safe. Together, they replace "hoping the AI does the right thing" with infrastructure that guarantees it.
