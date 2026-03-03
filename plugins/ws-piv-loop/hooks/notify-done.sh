#!/bin/bash
# ─────────────────────────────────────────────────────────────
# notify-done.sh — Stop hook
#
# Fires every time Claude finishes responding.
# Sends a macOS notification so you know Claude is done,
# even if you've switched to another window or tab.
#
# Great for long-running tasks where you fire-and-forget.
# On Linux, swap osascript for notify-send.
# ─────────────────────────────────────────────────────────────

osascript -e 'display notification "Claude is done" with title "Claude Code"' 2>/dev/null
exit 0
