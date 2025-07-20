#!/bin/bash

# --- ENVIRONMENT VARIABLES ---


# --- FUNCTIONS ---


# --- ALIASES ---


# --- COMPLETIONS ---
#===============================================
# fd (Rust-based Find) Auto-Completion SCRIPT   #
#===============================================
# Official repo: https://github.com/sharkdp/fd
# Bash completion is supported via: `fd --completion bash`
# This loads `fd` auto-completion in Bash if it's installed and in PATH.

if command -v fd &>/dev/null; then
    # shellcheck disable=SC1090
    source <(fd --gen-completions bash)
fi

# If you want better performance (recommended), store the generated script once:
# fd --gen-completions bash > ~/.bash_completions/fd
# Then source it in your .bashrc or .bash_profile:
# if [ -f ~/.bash_completions/fd ]; then
#     source ~/.bash_completions/fd
# fi