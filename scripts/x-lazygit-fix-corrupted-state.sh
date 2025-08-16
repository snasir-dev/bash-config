#!/usr/bin/env bash

#========================================================
# Fix Lazygit error 'yaml: control characters are not allowed'
# Issue occurs if Lazygit is open and computer crashes
# Solution: Remove 'state.yml' file from
#========================================================

# Define plugin destination path using LOCALAPPDATA
LAZYGIT_DIR="$LOCALAPPDATA/lazygit"
LAZYGIT_DIR_WINDOWS_PATH=$(cygpath -w "$LAZYGIT_DIR")

echo "📂 Lazygit directory (Linux path): $LAZYGIT_DIR"
echo "🔍 Lazygit directory (Windows path): $LAZYGIT_DIR_WINDOWS_PATH"
echo

STATE_FILE="$LAZYGIT_DIR/state.yml"
BACKUP_FILE="$LAZYGIT_DIR/state.yml.bak"

# Check if state.yml exists
if [ -f "$STATE_FILE" ]; then
    echo "✅ Found state.yml at: $STATE_FILE"

    if [ -f "$BACKUP_FILE" ]; then
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        NEW_BACKUP_FILE="$LAZYGIT_DIR/state.yml.bak.$TIMESTAMP"
        echo "⚠️ Backup file already exists. Creating timestamped backup instead: $NEW_BACKUP_FILE"
        mv "$STATE_FILE" "$NEW_BACKUP_FILE"
    else
        echo "📦 Renaming state.yml → state.yml.bak"
        mv "$STATE_FILE" "$BACKUP_FILE"
    fi

    echo "🎉 Done! You can now restart Lazygit."
else
    echo "❌ No state.yml file found at: $STATE_FILE"
    echo "Nothing to fix."
fi

echo "📂 Opening Lazygit Local directory in File Explorer..."
echo "🔍 Lazygit Directory (Windows Path): $LAZYGIT_DIR_WINDOWS_PATH"

explorer "$LAZYGIT_DIR_WINDOWS_PATH"
