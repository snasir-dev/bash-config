#!/bin/bash
# The .bashrc and .bash_profile files must remain in our home directory (~ or /c/Users/<username> if using Windows).
# This is because these are the specific locations where Bash looks for these files by default during startup, and this behavior is not configurable without modifying the Bash source code.

# Editing either the .bashrc in $HOME or in this repository .config/setup/.bashrc will have the same effect. The change will be immediately reflected across both.

# =====================================================================================
# This is the BASH REPO Location that is used in many files.
# If we ever change the location of this bash repo:
# 1. Update this variable in .bashrc
# 1b. Update this variable in .bash_profile
# 2. setup_bash.sh: Update ONLY "BASH_REPO_DIR" variable script with the new path
#   - This is because that is run once initially PRIOR to the .bashrc being sourced
# 3. README.md: Lastly, update README.md to reflect new location.
# =====================================================================================

# export BASH_DIR="~/.bash"
export BASH_DIR="$HOME/.config/bash"

if [ -f "$BASH_DIR/main.sh" ]; then
	source "$BASH_DIR/main.sh"
fi
