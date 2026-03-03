#!/bin/bash
# Stop hook: macOS notification when Claude finishes
osascript -e 'display notification "Claude is done" with title "Claude Code"' 2>/dev/null
exit 0
