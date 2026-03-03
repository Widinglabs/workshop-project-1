# Claude Code Hooks

Shell commands that run automatically at lifecycle events. Deterministic guardrails — they always fire, unlike instructions the LLM might ignore.

## How It Works

Hooks are configured in `.claude/settings.json` (project) or `~/.claude/settings.json` (user). They receive JSON on stdin and control flow via exit codes:

| Exit Code | Effect |
|-----------|--------|
| `0` | Allow — action proceeds |
| `2` | Block — action stopped, stderr message fed back to Claude |
| Other | Ignore — action proceeds, stderr logged |

## Hooks in This Project

| File | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse (Bash) | Blocks dangerous commands: `rm -rf /`, `DROP TABLE`, force push to main, `git reset --hard` |
| `guard-files.sh` | PreToolUse (Write\|Edit) | Blocks writes to `.env`, private keys, credential files |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

## Configuring Hooks

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/guard-bash.sh",
            "timeout": 3
          }
        ]
      }
    ]
  }
}
```

## Available Events

`SessionStart` · `PreToolUse` · `PostToolUse` · `PostToolUseFailure` · `Stop` · `Notification` · `SubagentStart` · `SubagentStop`

See [docs](https://docs.anthropic.com/en/docs/claude-code/hooks) for the full list.
