#!/bin/bash
# PreToolUse guard for Bash: block dangerous commands + protect main branch
# Exit 2 = block (stderr sent to Claude as feedback)
INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
[ -z "$CMD" ] && exit 0
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# ── Destructive commands ──

# rm -rf targeting root, home, or parent
if echo "$CMD" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*\s+)+(/\s*$|/\*|~\s*$|~/\s*$|\.\.\s*$|\$HOME\s*$|\$HOME/)'; then
    echo "BLOCKED: rm targets a dangerous path. Ask the user to confirm." >&2
    exit 2
fi

# DROP TABLE / DROP DATABASE / TRUNCATE
if echo "$CMD" | grep -qiE '(DROP\s+(TABLE|DATABASE|SCHEMA)|TRUNCATE\s+TABLE)'; then
    echo "BLOCKED: Destructive SQL detected. Ask the user to confirm." >&2
    exit 2
fi

# ── Safer alternatives ──

# Force push to main/master
if echo "$CMD" | grep -qE 'git\s+push\s+.*(-f|--force).*\s+(main|master)\b'; then
    echo "BLOCKED: Force push to main/master is not allowed. Use git revert or create a PR." >&2
    exit 2
fi

# git reset --hard
if echo "$CMD" | grep -qE 'git\s+reset\s+--hard'; then
    cat >&2 <<MSG
BLOCKED: git reset --hard discards all uncommitted changes permanently.
Safer alternatives:
  git stash                    # save changes first
  git checkout -- <file>       # discard specific file
MSG
    exit 2
fi

# git clean -f
if echo "$CMD" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f'; then
    cat >&2 <<MSG
BLOCKED: git clean -f permanently deletes untracked files.
Safer approach:
  git clean -n    # dry run - see what would be deleted first
  git stash -u    # stash untracked files instead of deleting
MSG
    exit 2
fi

# ── Branch protection ──
if echo "$CMD" | grep -qE '^git\s+commit'; then
    if [ -n "$CWD" ] && [ -d "$CWD" ]; then
        BRANCH=$(cd "$CWD" && git branch --show-current 2>/dev/null)
        if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
            echo "BLOCKED: Direct commits to $BRANCH are not allowed. Create a feature branch first." >&2
            exit 2
        fi
    fi
fi

exit 0
