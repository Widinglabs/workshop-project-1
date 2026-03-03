# Claude Code — Workshop Showcase

Reference for features demonstrated during the workshop, ordered to match the presentation flow.

---

## 1. CLAUDE.md — Project Onboarding (Slides 24-26)

Always loaded. Every conversation, every task. The project's single source of truth for AI sessions.

```
CLAUDE.md              # Project root — always in context
.claude/CLAUDE.md      # Alternative location (same behavior)
CLAUDE.local.md        # Personal overrides (gitignored)
~/.claude/CLAUDE.md    # User-wide (all projects)
```

What belongs: build commands, project structure, coding standards, security rules, workflows.
What doesn't: task-specific details, temporary decisions.

Run `/init` to auto-generate a starting CLAUDE.md from your codebase.

---

## 2. Skills and Slash Commands (Slides 27-28)

Reusable workflows stored as markdown. Invoke with `/skill-name`.

```
.claude/skills/my-skill/
├── SKILL.md           # Instructions + YAML frontmatter
├── templates/         # Templates Claude fills in (optional)
└── examples/          # Example outputs (optional)
```

### Workshop Skills (`/ws-*`)

| Command | Purpose |
|---------|---------|
| `/ws-prime` | Load full codebase context |
| `/ws-plan-feature` | Generate an implementation plan |
| `/ws-implement` | Execute plan with validation loops |
| `/ws-validate` | Run lint, type-check, tests |
| `/ws-review` | Code review with severity ratings |
| `/ws-install` | Set up dependencies, start servers |

These follow the **PIV Loop**: Plan → Implement → Validate.

### Built-in Skills

| Command | Purpose |
|---------|---------|
| `/simplify` | Spawns 3 parallel agents reviewing code for reuse, quality, efficiency — then fixes issues |
| `/batch` | Decomposes large changes into parallel units, each in an isolated worktree |
| `/init` | Auto-generates CLAUDE.md from your codebase |
| `/memory` | View loaded rules and auto-memory |
| `/debug` | Troubleshoot your Claude Code session |

---

## 3. PRP Framework (Slides 34-36)

One framework covering every SDLC phase. Install: `claude plugin add github:Wirasm/PRPs-agentic-eng/plugins/prp-core`

| Phase | Command | What it does |
|-------|---------|-------------|
| Planning | `/prp-prd` | Interactive PRD generation |
| Architecture | `/prp-plan` | Parallel codebase exploration → implementation plan |
| Implementation | `/prp-implement` | Task-by-task execution with validation |
| Bug Fixing | `/prp-issue-investigate` | Root cause analysis from GitHub issues |
| Research | `/prp-codebase-question` | Parallel agents investigate your codebase |
| Code Review | `/prp-review-agents` | 7 specialized reviewers in parallel |
| Version Control | `/prp-commit`, `/prp-pr` | Smart staging, template detection |

---

## 4. Validation Pyramid (Slide 38)

| Layer | Responsibility | Who |
|-------|---------------|-----|
| Syntax | Linting, formatting | Agent |
| Types | TypeScript, mypy | Agent |
| Unit | Component tests | Agent |
| Integration | Cross-component, E2E | 80/20 Agent/Human |
| Human | Architecture, UX, business logic | Human |

Validation is built into every PRP command. The AI validates its own work before you review.

---

## 5. Path-Scoped Rules (Slide 40)

Rules load on-demand when Claude reads matching files. Right context at the right time.

```
.claude/rules/
├── backend.md       # paths: ["app/backend/**/*.py"]
├── frontend.md      # paths: ["app/frontend/**/*.{ts,tsx}"]
└── testing.md       # paths: ["app/backend/tests/**/*.py"]
```

Rules without `paths:` frontmatter load at launch (like CLAUDE.md). Rules with `paths:` load only when Claude reads matching files.

---

## 6. Hooks — Automated Guardrails (Slide 41)

Shell commands at lifecycle events. Deterministic — always fire, can't be ignored by the LLM.

| Hook | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse (Bash) | Blocks `rm -rf /`, `DROP TABLE`, force push, commits on main |
| `guard-files.sh` | PreToolUse (Write\|Edit) | Blocks writes to `.env`, credentials, private keys |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

Exit code `0` = allow, `2` = block (stderr sent back to Claude as feedback).

Available events: `SessionStart` · `PreToolUse` · `PostToolUse` · `PostToolUseFailure` · `Stop` · `Notification` · `SubagentStart` · `SubagentStop` · `TaskCompleted` · `TeammateIdle`

---

## 7. Parallel Development — Worktrees (Slide 42)

Each agent gets its own isolated copy of the repo. No file conflicts, no branch collisions.

```bash
claude --worktree feature-auth    # Creates .claude/worktrees/feature-auth/
claude -w bugfix-123              # Separate branch, separate files
```

Run 3-5 agents simultaneously. Worktrees share project config (skills, hooks, rules) but have isolated file and git state. Cleanup is automatic when no changes are made.

---

## 8. Subagents (Slide 43)

Spawn specialized agents for focused tasks. Each gets its own context window.

- Review code in parallel with 7 different reviewers
- Research your codebase with explorer + analyst agents
- Run security audits while you continue building

Results are summarized back to the main session.

---

## 9. Agent Teams (Experimental)

Multiple Claude Code instances collaborating on a shared project. One "team lead" spawns "teammates" — each with their own context window, coordinating through a shared task list and direct messaging.

```bash
# Enable in settings.json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```

Good for: parallel code review, competing debug hypotheses, splitting features across backend/frontend/tests.

---

## 10. Remote Control

Start Claude locally, continue from any browser or phone. Computation stays on your machine — the web UI is just a remote display.

```bash
claude remote-control    # Generates URL + QR code
/remote-control          # Enable from existing session
```

Great for out-of-loop work — fire off a task and check progress from your phone.

---

## 11. Headless Mode and Agent SDK

### CLI (`claude -p`)

```bash
claude -p "Find and fix the bug in auth.py"                    # One-shot
claude -p "Review this PR" --output-format json                # Structured output
```

Powers GitHub Actions (`@claude` mentions in PRs) and CI/CD pipelines.

### Agent SDK (Python / TypeScript)

```python
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Find and fix the bug in auth.py",
    options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"]),
):
    print(message.result)
```

Full programmatic control — tools, sessions, hooks, streaming.

---

## How It All Fits Together

1. **CLAUDE.md** — always loaded, sets project-wide standards
2. **Rules** — loaded on-demand for specific parts of the codebase
3. **Skills** — invoked to run structured workflows
4. **Hooks** — enforce guardrails automatically

The agent sees CLAUDE.md every session. Rules activate as it reads files. Skills give it playbooks. Hooks keep it safe. Together, they replace "hoping the AI does the right thing" with infrastructure that guarantees it.
