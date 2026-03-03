# ws-piv-loop Plugin

A Claude Code plugin packaging the **PIV Loop** workflow — Plan, Implement, Validate — with safety guardrails and notifications.

## Skills

| Command | Purpose |
|---------|---------|
| `/ws-piv-loop:ws-plan-feature` | Analyze codebase, generate implementation plan |
| `/ws-piv-loop:ws-implement` | Execute plan with validation after each step |
| `/ws-piv-loop:ws-validate` | Run lint, type-check, tests across the stack |
| `/ws-piv-loop:ws-review` | Code review with severity ratings |
| `/ws-piv-loop:ws-install` | Set up dependencies, start servers |
| `/ws-piv-loop:ws-prime` | Load full codebase context |

## Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse (Bash) | Blocks dangerous commands, protects main branch |
| `guard-files.sh` | PreToolUse (Write\|Edit) | Blocks writes to secrets and credentials |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

## Install

```bash
/plugin marketplace add Widinglabs/workshop-project-1
/plugin install ws-piv-loop@workshop-marketplace
```

## Test Locally

```bash
claude --plugin-dir ./plugins/ws-piv-loop
```
