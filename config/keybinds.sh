#!/bin/bash

#====================================================================
# CUSTOM KEYBINDS FOR BASH SHELL SCRIPT. OVERRIDE EXISTING BEHAVIOR #
#====================================================================

# Copy Current Terminal Prompt Source Reference: https://askubuntu.com/questions/413436/copy-current-terminal-prompt-to-clipboard

copy_line_to_win_clipboard () {
  printf %s "$READLINE_LINE" | clip.exe
}

# Bind CTRL+A to copy the current line to Windows clipboard. It DOES NOT clear the line.
bind -x '"\C-a": copy_line_to_win_clipboard'   # Bind to Ctrl+A
# bind -x '"\ec": copy_line_to_win_clipboard'  # Bind to ALT+C

copy_and_clear_line () {
  # Copy current input line to clipboard
  printf %s "$READLINE_LINE" | clip.exe

  # Clear the current line
  READLINE_LINE=""
  READLINE_POINT=0
}

# Bind Alt+U to copy the current line to Windows clipboard AND clear the line
bind -x '"\eu": copy_and_clear_line'            # Bind to Alt+U



#=====================================================================