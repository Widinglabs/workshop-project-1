# Claude Code — Workshop Showcase

Reference for features demonstrated during the workshop, ordered to match the presentation flow.

---

## 1. CLAUDE.md — Project Onboarding (Slides 25-27)

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

## 2. Skills and Slash Commands (Slides 28-29)

Reusable workflows stored as markdown. Invoke with `/skill-name`. See [`skills/README.md`](skills/README.md) for full details.

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

---

## 3. PRP Framework (Slides 35-37)

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

## 4. Validation Pyramid (Slide 39)

| Layer | Responsibility | Who |
|-------|---------------|-----|
| Syntax | Linting, formatting | Agent |
| Types | TypeScript, mypy | Agent |
| Unit | Component tests | Agent |
| Integration | Cross-component, E2E | 80/20 Agent/Human |
| Human | Architecture, UX, business logic | Human |

Validation is built into every PRP command. The AI validates its own work before you review.

---

## 5. Path-Scoped Rules (Slide 41)

Rules load on-demand when Claude reads matching files. Right context at the right time. See [`rules/README.md`](rules/README.md) for details.

```
.claude/rules/
├── backend.md       # paths: ["app/backend/**/*.py"]
├── frontend.md      # paths: ["app/frontend/**/*.{ts,tsx}"]
└── testing.md       # paths: ["app/backend/tests/**/*.py"]
```

Rules without `paths:` frontmatter load at launch (like CLAUDE.md). Rules with `paths:` load only when Claude reads matching files.

---

## 6. Hooks — Automated Guardrails (Slide 42)

Shell commands at lifecycle events. Deterministic — always fire, can't be ignored by the LLM. See [`hooks/README.md`](hooks/README.md) for details.

| Hook | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse (Bash) | Blocks `rm -rf /`, `DROP TABLE`, force push, commits on main |
| `guard-files.sh` | PreToolUse (Write\|Edit) | Blocks writes to `.env`, credentials, private keys |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

Exit code `0` = allow, `2` = block (stderr sent back to Claude as feedback).

---

## 7. MCP — Extending the Agent's Reach (Slide 43)

MCP (Model Context Protocol) connects Claude to external tools via a standard protocol. Configure in `.mcp.json` and commit — every team member gets the same toolset.

Available integrations: GitHub, Jira, Slack, Postgres, Sentry, SAP HANA, and hundreds more.

---

## 8. Built-in Skills: /simplify and /batch (Slide 44)

| Command | Purpose |
|---------|---------|
| `/simplify` | Spawns 3 parallel agents reviewing code for reuse, quality, efficiency — then fixes issues |
| `/batch` | Decomposes large changes into parallel units, each in an isolated worktree |
| `/security-review` | Analyzes pending changes for security vulnerabilities |
| `/review` | PR review for quality, correctness, security, test coverage |
| `/init` | Auto-generates CLAUDE.md from your codebase |
| `/memory` | View loaded rules and auto-memory |
| `/debug` | Troubleshoot your Claude Code session |

See [`skills/README.md`](skills/README.md) for the full list including built-in commands.

---

## 9. Plugins and Marketplaces (Slide 46)

Package skills, hooks, agents, and MCP servers into **distributable plugins**. Host them in a **marketplace** (a Git repo) for your team. See [`plugins/README.md`](../plugins/README.md) for a full guide.

This repo includes a working example at `plugins/`:

```
plugins/
├── .claude-plugin/
│   └── marketplace.json         # Registry listing available plugins
└── ws-piv-loop/                 # The PIV Loop plugin
    ├── .claude-plugin/plugin.json
    ├── skills/                  # All ws-* skills
    ├── hooks/                   # Guards + notification
    └── README.md
```

**Install:** `/plugin marketplace add Widinglabs/workshop-project-1`

**Enterprise pattern** — lock down to approved plugins with `strictKnownMarketplaces`.

---

## 10. Parallel Development — Worktrees (Slide 47)

Each agent gets its own isolated copy of the repo. No file conflicts, no branch collisions.

```bash
claude --worktree feature-auth    # Creates .claude/worktrees/feature-auth/
claude -w bugfix-123              # Separate branch, separate files
```

Run 3-5 agents simultaneously. Worktrees share project config (skills, hooks, rules) but have isolated file and git state.

---

## 11. Remote Control (Slide 48)

Start Claude locally, continue from any browser or phone. Computation stays on your machine — the web UI is just a remote display.

```bash
claude remote-control    # Generates URL + QR code
/remote-control          # Enable from existing session
```

Great for out-of-loop work — fire off a task and check progress from your phone.

---

## 12. Subagents and Agent Teams (Slide 49)

**Subagents** — specialized agents for focused tasks. Each gets its own context window, results flow back.

**Agent Teams** (experimental) — multiple Claude instances coordinate via shared task lists and direct messaging. Enable with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

---

## 13. Headless Mode and Agent SDK

Run Claude non-interactively for scripts and CI/CD:

```bash
claude -p "Find and fix the bug in auth.py"
claude -p "Review this PR" --output-format json
```

Agent SDK available for Python and TypeScript — full programmatic control.

---

## How It All Fits Together

1. **CLAUDE.md** — always loaded, sets project-wide standards
2. **Rules** — loaded on-demand for specific parts of the codebase
3. **Skills** — invoked to run structured workflows
4. **Hooks** — enforce guardrails automatically
5. **Plugins** — package and distribute all of the above across teams

The agent sees CLAUDE.md every session. Rules activate as it reads files. Skills give it playbooks. Hooks keep it safe. Plugins distribute it all. Together, they replace "hoping the AI does the right thing" with infrastructure that guarantees it.
