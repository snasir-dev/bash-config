#!/bin/bash
# The .bashrc and .bash_profile files must remain in our home directory (~ or /c/Users/<username> if using Windows).
# This is because these are the specific locations where Bash looks for these files by default during startup, and this behavior is not configurable without modifying the Bash source code.

# Editing either the .bashrc in $HOME or in this repository .config/setup/.bashrc will have the same effect. The change will be immediately reflected across both.

if [ -f ~/.bash/main.sh ]; then
	source ~/.bash/main.sh
fi
