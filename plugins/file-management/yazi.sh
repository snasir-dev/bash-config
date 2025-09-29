#!/bin/bash

# ============================================
# yazi - terminal file manager written in Rust, based on non-blocking async I/O. It aims to provide an efficient, user-friendly, and customizable file management experience.
# Github: https://github.com/sxyazi/yazi
# Docs: https://yazi-rs.github.io/docs/quick-start
# ============================================

# --- ENVIRONMENT VARIABLES / PATH ---
# By default Yazi uses '%AppData%\yazi\config\yazi.toml' on Windows
# To set ~/.config/yazi, must set that value in XDG_CONFIG_HOME env variable.
# Docs: https://yazi-rs.github.io/docs/configuration/overview#custom-directory
export YAZI_CONFIG_HOME="$HOME/.config/yazi"

# --- CONFIGURATION ---
# Docs: https://yazi-rs.github.io/docs/configuration/overview
# Yazi has default files (yazi-default, keymap-default, theme-dark.toml | theme-light.toml)
# To override, place a (yazi.toml, keymap.toml, theme.toml) file in the config directory. (For us will be $HOME/.config)

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

# Function to bootstrap Yazi config directory and empty files
yazi_create_config() {
    local config_dir="$HOME/.config/yazi"

    # Create root directory as well as "flavors" directory which is for themes.
    mkdir -p "$config_dir" "$config_dir/flavors"

    # Create empty config files if missing
    touch "$config_dir/yazi.toml" "$config_dir/keymap.toml" "$config_dir/theme.toml"

    # ya (DO NOT NEED TO SEPARATELY INSTALL )- built-in package manager comes bundled with YAZI dedicated to handling Yazi's themes and plugins
    # Install Theme - Ayu Dark (Themes gets installed in the flavors directory.)
    # List of all themes - REPO: https://github.com/yazi-rs/flavors/blob/main/README.md
    ya pkg add kmlupreti/ayu-dark
    # ya pkg add gosxrgxx/flexoki-dark
    ya pkg add 956MB/vscode-dark-modern
    # ya pkg add 956MB/vscode-dark-plus
    # ya pkg add bennyyip/gruvbox-dark

    echo -e "📃Listing pkg packages:\n"
    ya pkg list

    echo -e "\n✅ Yazi config initialized: $config_dir/yazi.toml, $config_dir/keymap.toml, $config_dir/theme.toml"
}

# --- ALIASES ---
# This will trigger y() function above instead of the yazi.exe executable. (If for any reason you need to trigger yazi.exe, run command 'command yazi')
alias yazi='y'

# --- COMPLETIONS ---
