#!/usr/bin/env bash

#========================================================
# Automatically install latest PowerToys Run plugin
#========================================================

# Define plugin destination path using LOCALAPPDATA
PLUGIN_DIR="$LOCALAPPDATA/Microsoft/PowerToys/PowerToys Run/Plugins"

# Define Downloads folder
DOWNLOADS="$USERPROFILE/Downloads"

#--------------------------------------------------------
# Step 1: Find latest zip file in Downloads using fd + fzf
#--------------------------------------------------------
echo "🔍 Select plugin .zip file (sorted by most recent):"
ZIP_FILE=$(fd --extension zip . "$DOWNLOADS" --type f --exec stat -c '%Y %n' {} \; 2>/dev/null | sort -nr | cut -d' ' -f2- | fzf --reverse)

if [[ -z "$ZIP_FILE" ]]; then
  echo "❌ No zip file selected. Exiting."
  exit 1
fi

echo "📦 Selected zip file: $ZIP_FILE"

#--------------------------------------------------------
# Step 2: Unzip selected file
#--------------------------------------------------------
# Create a temp folder for extraction
TEMP_DIR="$(mktemp -d)"
echo "📂 Extracting to temp folder: $TEMP_DIR"

if command -v 7z &> /dev/null; then
  7z x "$ZIP_FILE" -o"$TEMP_DIR" -y
elif command -v unzip &> /dev/null; then
  unzip -q "$ZIP_FILE" -d "$TEMP_DIR"
else
  echo "❌ Neither 7z nor unzip is installed. Please install one."
  exit 1
fi

#--------------------------------------------------------
# Step 3: Close PowerToys
#--------------------------------------------------------
echo "🛑 Closing PowerToys..."
taskkill //IM PowerToys.exe //F &> /dev/null

#--------------------------------------------------------
# Step 4: Move unzipped folder to Plugins directory
#--------------------------------------------------------

# Create Plugins directory if not exists
mkdir -p "$PLUGIN_DIR"

# Detect plugin root folder (assume first folder in TEMP_DIR)
PLUGIN_SRC=$(fd --type d . "$TEMP_DIR" --max-depth 1 | head -n 1)

if [[ -z "$PLUGIN_SRC" ]]; then
  echo "❌ Failed to find plugin folder inside archive."
  exit 1
fi

# Extract plugin folder name
PLUGIN_NAME=$(basename "$PLUGIN_SRC")

# Move to Plugins directory, overwrite if exists
# DEST="$PLUGIN_DIR/$PLUGIN_NAME"
DEST=$(cygpath -w "$PLUGIN_DIR\\$PLUGIN_NAME") # Convert to Windows path format with BACKWARD SLASHES (so we can easily copy paste the path from the output to FILE EXPLORER). Otherwise it was printing $PLUGIN_DIR with BACKSLASHES and then printing $PLUGIN_NAME with FORWARD SLASHES, which was causing issues.

# OUTPUT OF DEST: C:\Users\Syed\AppData\Local\Microsoft\PowerToys\PowerToys Run\Plugins\Weather

rm -rf "$DEST"
mv "$PLUGIN_SRC" "$DEST"

echo "✅ Plugin moved to: $DEST"

#--------------------------------------------------------
# Step 5: Restart PowerToys with fallback logic
#--------------------------------------------------------

# Define known shortcut and fallback executable
# Shortcut Windows Start Menu Path: C:\Users\Syed\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\PowerToys.lnk
SHORTCUT="$APPDATA/Microsoft/Windows/Start Menu/Programs/PowerToys.lnk"
# PowerToys Executable Path (Target path the Shortcut Points to): C:\Users\Syed\AppData\Local\PowerToys\WinUI3Apps\PowerToys.Settings.exe
EXECUTABLE="$LOCALAPPDATA/PowerToys/WinUI3Apps/PowerToys.Settings.exe"

SLEEP_TIME=7
echo "⏳ Waiting $SLEEP_TIME seconds before restarting PowerToys..."
echo "   This gives time to ensure clean shutdown and proper plugin registration..."
sleep $SLEEP_TIME

# Check if PowerToys is already running
if tasklist | grep -qi "PowerToys.Settings.exe"; then
  echo "ℹ️ PowerToys is already running. Skipping restart."
else
  echo "🚀 Attempting to restart PowerToys..."

  if [[ -f "$SHORTCUT" ]]; then
    echo "🔁 Launching via Start Menu shortcut..."
    start "" "$SHORTCUT"
  elif [[ -f "$EXECUTABLE" ]]; then
    echo "🔁 Shortcut not found. Launching directly from executable..."
    start "" "$EXECUTABLE"
  else
    echo "❌ Could not restart PowerToys."
    echo "   Neither shortcut nor executable found:"
    echo "   Shortcut: $SHORTCUT"
    echo "   Executable: $EXECUTABLE"
  fi
fi


#--------------------------------------------------------
# Done
#--------------------------------------------------------
echo "🎉 PowerToys plugin installed successfully!"
