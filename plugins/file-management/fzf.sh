#!/bin/bash

# --- ENVIRONMENT VARIABLES ---


# --- FUNCTIONS ---


# --- ALIASES ---


# --- COMPLETIONS ---

#====================================================================
# fzf (Fuzzy Finder) Auto-Completion + Key Bindings Setup  SCRIPT   #
#====================================================================
# Official Repo: https://github.com/junegunn/fzf
# Bash completion and key bindings are enabled via: `fzf --bash`
# This sets up fuzzy completion for commands like: cd, export, ssh, kill, etc.
# It also enables default key bindings for inline fuzzy search with Ctrl-T, Ctrl-R, and Alt-C:
#   - Ctrl-T: Paste selected file path(s) into the command line
#   - Ctrl-R: Fuzzy search command history
#   - Alt-C : Fuzzy cd into subdirectories (uses `find` or `fd`)
# These bindings greatly enhance file navigation and command recall in interactive shell sessions.
# Pre-requisite - Ensure `fzf` is installed and available in PATH.
# Can install on Windows with: choco install fzf


if command -v fzf &>/dev/null; then
    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --bash)"
fi

# See setting up fzf key bindings section for advanced customization options
# Source: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line