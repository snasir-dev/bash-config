#!/bin/bash

# ============================================
# yazi - terminal file manager written in Rust, based on non-blocking async I/O. It aims to provide an efficient, user-friendly, and customizable file management experience.
# Github: https://github.com/sxyazi/yazi
# Docs: https://yazi-rs.github.io/docs/quick-start
# ============================================

# --- ENVIRONMENT VARIABLES ---

# --- FUNCTIONS ---
# 'y' shell wrapper that provides the ability to change the current working directory when exiting Yazi.
# Link to Official Docs (where I got this from): https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# --- ALIASES ---
# This will trigger y() instead of the yazi.exe executable. (If for any reason you need to trigger yazi.exe, run command 'command yazi')
alias yazi='y'

# --- COMPLETIONS ---
