#!/bin/bash
# PreToolUse guard for Write|Edit: protect sensitive files
# Exit 2 = block (stderr sent to Claude as feedback)
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

BASENAME=$(basename "$FILE_PATH")
LOWER=$(echo "$BASENAME" | tr '[:upper:]' '[:lower:]')

# .env files
if echo "$LOWER" | grep -qE '^\.env($|\.)'; then
    echo "BLOCKED: Cannot write to $BASENAME - environment files contain secrets." >&2
    exit 2
fi

# Credential/secret files
if echo "$LOWER" | grep -qE '(credential|secret|password|token)s?\.'; then
    echo "BLOCKED: Cannot write to $BASENAME - likely contains secrets." >&2
    exit 2
fi

# Private keys and certificates
if echo "$LOWER" | grep -qE '\.(pem|key|p12|pfx|jks|keystore)$'; then
    echo "BLOCKED: Cannot write to $BASENAME - private keys must not be modified by AI." >&2
    exit 2
fi

# SSH keys
if echo "$LOWER" | grep -qE '^id_(rsa|ed25519|ecdsa|dsa)'; then
    echo "BLOCKED: Cannot write to $BASENAME - SSH keys must not be modified." >&2
    exit 2
fi

exit 0
