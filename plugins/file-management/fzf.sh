#!/bin/bash

#=======================================
# FZF - Setup a CUSTOM THEME for fzf
#=======================================
# FZF THEME PLAYGROUND (webpage where you can interactively create fzf themes): https://vitormv.github.io/fzf-themes/

LINE_SELECTION_COLOR="#FFA500" # Orange color for line selection within fzf.
# fg="#CBE0F0"
# bg="#011628"
# bg_highlight="#143652"
# purple="#B388FF"
# blue="#06BCE4"
# cyan="#2CF9ED"

# export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# ============================================
# Key Bindings (Additional)
# ============================================

# Custom key bindings for common operations
# bind '"\C-g\C-f": "$(fd --type file | fzf)\e\C-e"'  # Ctrl+G, Ctrl+F for files
# bind '"\C-g\C-d": "cd $(fd --type directory | fzf)\n"'  # Ctrl+G, Ctrl+D for directories
# bind '"\C-g\C-b": "git checkout $(git branch | fzf | sed \"s/^[ *]*//\")\n"'  # Ctrl+G, Ctrl+B for branches
# bind '"\C-g\C-h": "$(history | fzf | sed \"s/^[ ]*[0-9]*[ ]*//\")\e\C-e"'  # Ctrl+G, Ctrl+H for history

# --- LOCAL VARIABLES ---
LIMIT_FILE_LINES=500 # Limit the number of lines to preview in fzf

# THEME COLORS

# --- ENVIRONMENT VARIABLES ---

# These are built in Env Variables within FZF that configure its behavior.

# For the default 'fzf' command. Now it will use 'fd' instead of 'find' for file searching.
# fd is faster search and IT AUTOMATICALLY excludes everything in .gitignore

# --hidden: include hidden files like .git and .env - BUT NOT ANYTHING in .gitignore
# --strip-cwd-prefix: Removes the ./ prefix from paths in the output. Ex: ./src/main.cs → src/main.cs (cleaner paths in fzf)
# --exclude .git: Exclude anything inside the .git directory from the search results
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'

# This will also set up a preview window that shows the first 500 lines of the file or a file tree showing only first 200 lines of the directory.
# It will also add keybinds where any file you have selected, if you press ctrl+o it will open in VS Code, or will copy FULL WINDOWS Path to clipboard if you press ctrl+a.
# Default keybinds of preview is shift up/down. We are adjusting HOW FAST it will scroll up or down. Here each 'preview-up' or 'preview-down' equals 1 line. So doing it 5 times will scroll 3 lines at once.

export FZF_DEFAULT_OPTS="
--preview 'if [ -d {} ]; then eza --tree --icons=always --color=always {} | head -200; else bat --style=full --color=always {}; fi'
--preview-window '~4' # Number of lines that will always show, will not scroll down.
--bind 'ctrl-o:execute(code {})+abort'
--bind 'ctrl-a:execute-silent(readlink -f {} | cygpath -m -f - | clip)'
--bind 'shift-up:preview-up+preview-up+preview-up'
--bind 'shift-down:preview-down+preview-down+preview-down'
--header 'ctrl-o: Open in VSCode, ctrl-a: Copy Full Windows Path | shift-up/down: Scroll Preview'
--color=header:$LINE_SELECTION_COLOR
--reverse
"

# What happens in fzf when we press Ctrl+T. It will be the same as FZF_DEFAULT_COMMAND.
# For reference, CTRL+T can be triggered mid command to insert a value from fzf into the command line.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Options (Flags) for FZF when using Ctrl+T

# -- Options for CTRL+T (File & Directory Finder) --
# We use a multi-line double-quoted string here. This allows the shell to
# expand the ${LIMIT_FILE_LINES} variable. The single quotes around each
# option value protect special characters (like `{}`, `|`) from the shell,
# passing them correctly to fzf.

# This will also set up a preview window that shows the first 500 lines of the file or a file tree showing only first 200 lines of the directory.
# It will also add keybinds where any file you have selected, if you press ctrl+o it will open in VS Code, or will copy FULL WINDOWS Path to clipboard if you press ctrl+a.
export FZF_CTRL_T_OPTS="
--preview 'if [ -d {} ]; then eza --tree --icons=always --color=always {} | head -200; else bat -n --color=always --line-range :${LIMIT_FILE_LINES} {}; fi'
--bind 'ctrl-o:execute(code {})+abort'
--bind 'ctrl-a:execute-silent(readlink -f {} | cygpath -m -f - | clip)'
--header 'ctrl-o: Open in VSCode, ctrl-a: Copy Full Windows Path'
--color=header:$LINE_SELECTION_COLOR
"

# ALT+C by default searches for ONLY directories starting from current directory in fzf.
# Adding 'fd --type=d' will ensure it only lists directories.
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# Automatically passes options to fzf when using ALT+C
# export FZF_ALT_C_OPTS="--preview 'eza --tree --icons=always --color=always {} | head -200'"
# Similar to FZF_CTRL_T_OPTS, only difference is that it doesn't need condition to check if it is a file or directory as this command only lists directories. 'color=header sets the color of the header in fzf.'
export FZF_ALT_C_OPTS="
--preview 'eza --tree --icons=always --color=always {} | head -200'
--bind 'ctrl-o:execute(code {})+abort'
--bind 'ctrl-a:execute-silent(readlink -f {} | cygpath -m -f - | clip)'
--header 'ctrl-o: Open in VSCode, ctrl-a: Copy Full Windows Path'
--color=header:$LINE_SELECTION_COLOR
"

# --- FUNCTIONS ---

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# This is for the ** fzf COMPLETION when looking for files and directories.
# Used by fzf to list file and dir candidates for path completions (e.g., vim **<TAB>)
# Good explanation of the function: https://youtu.be/mmqDYw9C30I?t=301
_fzf_compgen_path() {
    fd --hidden --follow --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
# This is for the ** <TAB-KEY> functionality like cd ** <tab-key-to-trigger-fzf>
# Used by fzf to list only directories for DIRECTORY-ONLY completions (e.g., cd **<TAB>)
# $1 is the base directory to search in
# Source: https://github.com/junegunn/fzf?tab=readme-ov-file#customizing-completion-source-for-paths-and-directories
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

#===========================================================
# FZF BETTER AUTO PREVIEW SETUP
#===========================================================
# Timestamp for customization: https://youtu.be/mmqDYw9C30I?t=727

# Advanced customization of fzf options via _fzf_comprun function
# The _fzf_comprun() function is a special hook used by fzf completion to customize how fuzzy results are displayed during tab-completion (e.g., cd **<TAB>, export **<TAB>, etc.).
# Each case customizes the preview window shown in fzf during that kind of completion

# Called by fzf-tab-completion to customize preview behavior based on command context
# $1 = command triggering the completion (e.g., cd, ssh, export)
# $@ = any extra arguments passed from fzf's completion engine
# See Source: https://github.com/junegunn/fzf?tab=readme-ov-file#customizing-fzf-options-for-completion
_fzf_comprun() {
    local command=$1 # Extract command name (e.g. cd, ssh)
    shift            # Shift off the command name so $@ is just fzf args

    case "$command" in
        # Triggered when running: cd **<TAB>
        # Shows a directory tree preview of the selected folder using eza
        cd)
            fzf --preview 'eza --tree --icons=always --color=always {} | head -200' "$@"
            ;;

        # Triggered when running: export **<TAB> or unset **<TAB>
        # Shows the current value of each environment variable
        export | unset)
            fzf --preview "eval 'echo $'{}" "$@"
            ;;

        # Triggered when running: ssh **<TAB>
        # Shows DNS info (IP address, etc.) for selected host using `dig`
        ssh)
            fzf --preview 'dig {}' "$@"
            ;;

        # Fallback: used for all other commands (e.g., vim **<TAB>, cat **<TAB>)
        # Shows syntax-highlighted file preview using bat, limited to $LIMIT_FILE_LINES lines
        *)
            fzf --preview "bat -n --color=always --line-range :$LIMIT_FILE_LINES {}" "$@"
            ;;
    esac
}

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

if command -v fzf &> /dev/null; then
    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --bash)"
fi

# See setting up fzf key bindings section for advanced customization options
# Source: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
