#!/bin/bash
# .bash_profile: Configuration file for login shells.
# This file is executed once per login session.

# Editing either the .bash_profile in $HOME or in this repository .config/setup/.bash_profile will have the same effect. The change will be immediately reflected across both.

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
