#!/bin/bash
# ─────────────────────────────────────────────────────────────
# guard-files.sh — PreToolUse hook for Write and Edit tools
#
# Fires BEFORE Claude writes or edits any file.
# Checks the target file path against patterns that should
# never be modified by AI: secrets, credentials, private keys.
#
# Exit 0 = allow, Exit 2 = block (message sent back to Claude)
# ─────────────────────────────────────────────────────────────

# Read the JSON payload — contains tool_input.file_path
INPUT=$(cat)

# Extract the file path Claude wants to write to
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

# Get just the filename for pattern matching
BASENAME=$(basename "$FILE_PATH")
LOWER=$(echo "$BASENAME" | tr '[:upper:]' '[:lower:]')

# ── Environment files (.env, .env.local, .env.production, etc.) ──
# These almost always contain API keys, database URLs, and secrets.
# AI should write to .env.example instead (without real values).
if echo "$LOWER" | grep -qE '^\.env($|\.)'; then
    echo "BLOCKED: Cannot write to $BASENAME - environment files contain secrets." >&2
    exit 2
fi

# ── Files with "credential", "secret", "password", or "token" in the name ──
# Catches things like credentials.json, secrets.yaml, password-store.txt
if echo "$LOWER" | grep -qE '(credential|secret|password|token)s?\.'; then
    echo "BLOCKED: Cannot write to $BASENAME - likely contains secrets." >&2
    exit 2
fi

# ── Private keys and certificates (.pem, .key, .p12, .pfx, .jks, .keystore) ──
# These are cryptographic material — should only be managed by proper tooling
if echo "$LOWER" | grep -qE '\.(pem|key|p12|pfx|jks|keystore)$'; then
    echo "BLOCKED: Cannot write to $BASENAME - private keys must not be modified by AI." >&2
    exit 2
fi

# ── SSH keys (id_rsa, id_ed25519, id_ecdsa, id_dsa) ──
# Modifying these would break authentication
if echo "$LOWER" | grep -qE '^id_(rsa|ed25519|ecdsa|dsa)'; then
    echo "BLOCKED: Cannot write to $BASENAME - SSH keys must not be modified." >&2
    exit 2
fi

# File path is safe — allow the write/edit
exit 0
