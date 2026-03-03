# Claude Code Skills

## Workshop Skills (`/ws-*`)

Custom skills for the PIV Loop workflow. See each `SKILL.md` for details.

| Command | Purpose |
|---------|---------|
| `/ws-prime` | Load full codebase context into the agent |
| `/ws-plan-feature` | Analyze codebase and generate an implementation plan |
| `/ws-implement` | Execute a plan with validation after each step |
| `/ws-validate` | Run lint, type-check, and tests across the stack |
| `/ws-review` | Code review with severity ratings |
| `/ws-install` | Set up dependencies and start servers |

## Built-in Skills

Claude Code ships with these skills out of the box — no setup needed.

### `/simplify` — Automated Code Cleanup

Spawns **3 parallel review agents** on your recently changed files:

1. **Code Reuse** — finds duplicated patterns, checks if existing utilities already handle the logic
2. **Code Quality** — evaluates naming, function decomposition, control flow clarity
3. **Efficiency** — spots unnecessary allocations, redundant loops, operations that could be batched

Then fixes the issues it finds. Use it between "it works" and "it's ready to merge."

```
/simplify
/simplify focus on memory efficiency
```

### `/batch` — Parallel Codebase-Wide Changes

Orchestrates large-scale changes using multiple isolated agents:

1. You describe the change: `/batch migrate src/ from Solid to React`
2. Claude explores the codebase, decomposes into 5-30 independent units
3. Presents a plan for your approval
4. Spawns **one agent per unit in isolated git worktrees** — all running simultaneously
5. Each agent implements, tests, and opens a PR

Perfect for migrations, large refactors, framework swaps.

### `/init` — Generate CLAUDE.md

Scans your codebase and generates a starting CLAUDE.md with project structure, build commands, and conventions. Run once, then refine.

### `/memory` — View Loaded Context

Shows all loaded CLAUDE.md files, rules, and auto-memory. Useful for debugging why Claude does or doesn't know something.

### `/debug` — Session Troubleshooting

Reads your session debug log and diagnoses issues. Optional description to focus the analysis.

```
/debug why did my last command fail
```

## Creating New Skills

Add a directory under `.claude/skills/` with a `SKILL.md` entrypoint:

```
.claude/skills/my-skill/
├── SKILL.md           # Instructions + YAML frontmatter
├── templates/         # Templates Claude fills in (optional)
└── examples/          # Example outputs (optional)
```

Frontmatter options:

```yaml
---
description: What this skill does (shown in command palette)
argument-hint: <what to pass>
---
```

If you repeat instructions 3+ times, make it a skill.
