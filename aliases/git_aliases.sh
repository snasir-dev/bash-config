#!/bin/bash
#*******************************
# Git Aliases

alias gs="git status"
# alias ga="git add"
# alias gc="git commit -m"
# alias gp="git push"
alias gl="git log --oneline --graph --decorate --all" # can add additional commands after it like number of lines "-n 20"
alias gfsck="git_fsck"

# Alias for LazyGit - A TERMINAL USER INTERFACE for GIT
# alias lg="lazygit" LG="lazygit" Lg="lazygit"

# shellcheck disable=SC2139
# Brace expansion {lg,LG,Lg} generates three separate aliases (lg, LG, Lg) in a single command. Bash processes this during startup with no runtime performance difference
alias {lg,LG,Lg,lG}="lazygit"

# All
# alias lg="lazygit"
# alias LG="lazygit"
# alias Lg="lazygit"

#*******************************
