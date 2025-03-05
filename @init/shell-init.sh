# Main BASH configuration file that will be sourced by the .bashrc file. 
# This file acts as the central point for sourcing all custom configurations from ~/.bash directory.
# The .bashrc file will be very simple, it will only source this file.
# Example of sourcing main configuration from .bash directory. Only the following lines below will be added to .bashrc file located in the home directory.
# if [ -f ~/.bash/main ]; then
#     source ~/.bash/main
# fi


# Check if shell is running interactively
# $- is a string containing current shell options (i = interactive shell)
# != means "not equal to"
# *i* checks if 'i' appears anywhere in the string
# && means "and" - only execute the next command if the previous one is true
# return exits the script if shell is non-interactive
[[ $- != *i* ]] && return

# Iterate through all files in the env directory
# for file in: starts a loop that will process each matching file
# ~/.bash/env/*: expands to all files in the env directory
# do: begins the loop body
for file in ~/.bash/env/*; do
    # Check if the current $file is a regular file (not a directory)
    # [ -f "$file" ]: test if $file exists and is a regular file
    # "$file" is quoted to handle filenames with spaces
    # && means only execute the next command if this test is true
    [ -f "$file" ] && source "$file"  # source loads the file's contents into current shell
done

# IMPORTANT: functions must be loaded before aliases because aliases depend on functions
# Source all function definitions
# Same pattern as above, but for files in the functions directory
for file in ~/.bash/functions/*; do
    [ -f "$file" ] && source "$file"
done

# Source all alias definitions
# Same pattern as above, but for files in the aliases directory
for file in ~/.bash/aliases/*; do
    [ -f "$file" ] && source "$file"
done

# Source all completion scripts
# Same pattern as above, but for files in the completions directory
for file in ~/.bash/completions/*; do
    [ -f "$file" ] && source "$file"
done

# Add scripts directory to PATH
# export makes the variable available to child processes
# PATH is the system variable that defines where to look for executables
# $HOME expands to your home directory
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