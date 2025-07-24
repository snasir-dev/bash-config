#!/bin/bash

# eza OFFICIAL GITHUB: https://github.com/eza-community/eza
# eza is a modern alternative for the venerable file-listing command-line program ls that ships with Unix and Linux operating systems, giving it more features and better defaults. It uses colors to distinguish file types and metadata. It knows about symlinks, extended attributes, and Git. And it’s small, fast, and just one single binary.

# By deliberately making some decisions differently, eza attempts to be a more featureful, more user-friendly version of ls.

# --- ENVIRONMENT VARIABLES ---


# --- FUNCTIONS ---


# --- ALIASES ---


# --- COMPLETIONS ---

#=================================================
# eza Auto-Completion SCRIPTS                    #
#=================================================
# Official eza Documentation: https://eza.rocks/completion
# NO OFFICIAL eza --completions bash command available.
# Instead eza provides a script that can be sourced to enable completions.
# Run command:
# curl -Lo ~/.bash/completions/packages/eza.bash https://raw.githubusercontent.com/eza-community/eza/main/completions/bash/eza
# This downloads the eza completion script from (ROOT_EZA_REPO/completions/bash/eza) to the ~/.bash/completions/packages/eza.bash
# Sourcing this output enables tab completion for eza flags and options.
# Pre-requisite - Ensure eza is installed and available in PATH.
# Can install on Windows with command: choco install eza -y

# -f ~/.bash/completions/eza.bash checks if the file exists before sourcing it.
if command -v eza &>/dev/null && [[ -f ~/.bash/completions/eza.bash ]]; then    
    source ~/.bash/completions/packages/eza.bash
fi