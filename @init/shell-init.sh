#!/bin/bash
# Main BASH configuration file that will be sourced by the .bashrc file.
# This file acts as the central point for sourcing all custom configurations from ~/.bash directory.
# The .bashrc file will be very simple, it will only source this file.
# Example of sourcing main configuration from .bash directory. Only the following lines below will be added to .bashrc file located in the home directory.
# if [ -f ~/.bash/main ]; then
#     source ~/.bash/main
# fi

# Enable debug logs (set to false to silence sourcing output)
DEBUG=true

# Check if shell is running interactively
# $- is a string containing current shell options (i = interactive shell)
# != means "not equal to"
# *i* checks if 'i' appears anywhere in the string
# && means "and" - only execute the next command if the previous one is true
# return exits the script if shell is non-interactive
[[ $- != *i* ]] && return

# -----------------------------
# Helper: safely source all '.sh' files under a directory and its sub-directories
# Arguments:
#   $1 = label (used for debug messages: env/functions/aliases/completions)
#   $2 = base directory to search within
# -----------------------------
source_sh_files() {
    local label="$1" # Label used to indicate source type (e.g., "env")
    local dir="$2"   # Directory path to search for .sh files

    # Use `find` to locate all `.sh` files under the directory tree
    #   -type f      → only files (not directories)
    #   -name "*.sh" → only files ending with .sh
    #   -print0      → output null-separated paths (safe for filenames with spaces/newlines)
    #
    # `while IFS= read -r -d '' file; do ... done < <(...)` is process substitution:
    # - IFS=         → disables word splitting, reads the whole line
    # - -r           → disables backslash escaping
    # - -d ''        → sets the delimiter to null (for use with `-print0`)
    # - < <(...)     → process substitution feeds output of `find` into the loop, safely
    #
    # This ensures robust and safe reading of file paths, even those with special characters
    while IFS= read -r -d '' file; do
        # If debugging is enabled, print the file being sourced
        [[ $DEBUG == true ]] && echo "Sourcing [$label]: $file"
        # Source the file into the current shell (not a subshell)
        source "$file"
    done < <(find "$dir" -type f -name "*.sh" -print0)
}

# -----------------------------
# Source scripts in order: env → functions → aliases → completions
# -----------------------------
source_sh_files "env" ~/.bash/env
# !! IMPORTANT: FUNCTIONS MUST BE BE SOURCED BEFORE ALIASES (SOME ALIASES WILL DEPEND ON THEM) !!
source_sh_files "functions" ~/.bash/functions
source_sh_files "aliases" ~/.bash/aliases
source_sh_files "completions" ~/.bash/completions

# Add scripts directory to PATH
# export makes the variable available to child processes
# PATH is the system variable that defines where to look for executables
# $HOME expands to our home directory
# : is the path separator in PATH
# $PATH appends the existing PATH value
export PATH="$HOME/.bash/scripts:$PATH"

# Source local machine-specific settings
# These settings shouldn't be in version control
# if [ -f file ]: tests if the file exists and is a regular file
# then: begins the block of code to execute if the test is true
# fi: ends the if block
if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi

# Source Theme Configuration
# Install and Setup Oh My Posh (Custom Prompt Tool to add themes to the terminal)
# Check if 'setup-oh-my-posh.sh' file exists. If it does, source it.
if [ -f ~/.bash/themes/setup-oh-my-posh.sh ]; then
    source ~/.bash/themes/setup-oh-my-posh.sh
else
    echo "Warning: setup-oh-my-posh.sh not found! Please check your installation."
fi
