#!/bin/bash


# Have added this script to PATH. Can directly call the script by just stating "x-script-selector". 
# Also have added an alias for it in aliases/aliases.sh file.
# can use "scripts" alias command to run this script.

# This script allows you to select and run scripts interactively using fzf.

# Best practice to use kebab-case for script names, e.g., "x-script-selector.sh". It is easier to type.
x-script-selector() {
  echo "📝  Starting script selection using fzf..."

  # 1. Define the directory where your scripts are located
  local scripts_dir="$HOME/.bash/scripts"

  # 2. Check if the script directory actually exists
  if [[ ! -d "$scripts_dir" ]]; then
    echo "Error: Scripts directory not found at '$scripts_dir'"
    return 1
  fi

  # 3. Find executable scripts and pipe them to fzf for selection
  local selected_script
  selected_script=$(find "$scripts_dir" -maxdepth 1 -type f -executable | fzf \
    --height 50% \
    --layout=reverse \
    --border=rounded \
    --preview 'bat --color=always --style=plain --line-range :200 {} || cat {} | head -n 200' \
    --prompt="Select a script to run > ")

  # 4. If a script was selected, execute it
  if [[ -n "$selected_script" ]]; then
    echo "▶️  Executing: $(basename "$selected_script")"
    # Execute the script, passing along any arguments you provided to the `scripts` command
    "$selected_script" "$@"
  else
    echo "🚫 No script selected."
  fi
}

# CALL FUNCTION

# "$@" is a special variable that represents all the command-line arguments passed to your script. The double quotes are crucial because they ensure each argument is treated as a separate entity, even if it contains spaces.
x-script-selector "$@"