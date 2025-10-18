#!/bin/bash
# .bash_profile: Configuration file for login shells.
# This file is executed once per login session.

# Editing either the .bash_profile in $HOME or in this repository .config/setup/.bash_profile will have the same effect. The change will be immediately reflected across both.

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
