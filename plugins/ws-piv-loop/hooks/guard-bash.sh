#!/bin/bash
# ─────────────────────────────────────────────────────────────
# guard-bash.sh — PreToolUse hook for the Bash tool
#
# Fires BEFORE every Bash command Claude tries to run.
# Claude sends us JSON on stdin with the command it wants to execute.
# We parse it, check against our rules, and either:
#   exit 0  → allow (command runs normally)
#   exit 2  → block (command is stopped, our stderr message
#             is sent back to Claude as feedback so it can adjust)
# ─────────────────────────────────────────────────────────────

# Read the JSON payload from stdin (contains tool_input.command, cwd, etc.)
INPUT=$(cat)

# Extract the shell command Claude wants to run
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
[ -z "$CMD" ] && exit 0

# Extract the working directory (needed for branch detection)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# ══════════════════════════════════════════════════════════════
# DESTRUCTIVE COMMANDS — block and ask user to confirm manually
# These can cause irreversible damage if run accidentally.
# ══════════════════════════════════════════════════════════════

# rm -rf targeting root (/), home (~), or parent (..)
# AI agents sometimes hallucinate cleanup commands — this catches them
if echo "$CMD" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*\s+)+(/\s*$|/\*|~\s*$|~/\s*$|\.\.\s*$|\$HOME\s*$|\$HOME/)'; then
    echo "BLOCKED: rm targets a dangerous path. Ask the user to confirm." >&2
    exit 2
fi

# DROP TABLE / DROP DATABASE / TRUNCATE — protect production data
# Even in dev, these should be intentional and go through migrations
if echo "$CMD" | grep -qiE '(DROP\s+(TABLE|DATABASE|SCHEMA)|TRUNCATE\s+TABLE)'; then
    echo "BLOCKED: Destructive SQL detected. Ask the user to confirm." >&2
    exit 2
fi

# ══════════════════════════════════════════════════════════════
# SAFER ALTERNATIVES — block and suggest a better approach
# The intent is usually fine, but there's a less risky way.
# ══════════════════════════════════════════════════════════════

# Force push to main/master — rewrites shared history
if echo "$CMD" | grep -qE 'git\s+push\s+.*(-f|--force).*\s+(main|master)\b'; then
    echo "BLOCKED: Force push to main/master is not allowed. Use git revert or create a PR." >&2
    exit 2
fi

# git reset --hard — throws away all uncommitted work with no recovery
if echo "$CMD" | grep -qE 'git\s+reset\s+--hard'; then
    cat >&2 <<MSG
BLOCKED: git reset --hard discards all uncommitted changes permanently.
Safer alternatives:
  git stash                    # save changes first
  git checkout -- <file>       # discard specific file
MSG
    exit 2
fi

# git clean -f — permanently deletes untracked files (new files you haven't committed)
if echo "$CMD" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f'; then
    cat >&2 <<MSG
BLOCKED: git clean -f permanently deletes untracked files.
Safer approach:
  git clean -n    # dry run - see what would be deleted first
  git stash -u    # stash untracked files instead of deleting
MSG
    exit 2
fi

# ══════════════════════════════════════════════════════════════
# BRANCH PROTECTION — prevent direct commits to main/master
# Enforces the "always use feature branches" workflow.
# ══════════════════════════════════════════════════════════════

if echo "$CMD" | grep -qE '^git\s+commit'; then
    if [ -n "$CWD" ] && [ -d "$CWD" ]; then
        # Check which branch we're on in the project directory
        BRANCH=$(cd "$CWD" && git branch --show-current 2>/dev/null)
        if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
            echo "BLOCKED: Direct commits to $BRANCH are not allowed. Create a feature branch first." >&2
            exit 2
        fi
    fi
fi

# All checks passed — allow the command to run
exit 0
