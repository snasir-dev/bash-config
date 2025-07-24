#!/bin/bash
# ENV VARIABLES
#*******************************

# EXAMPLE OF ADDING COMMANDS TO PATH
# export PATH="$PATH:/path/to/your/command"
# Example: export PATH="$PATH:/c/Program Files/Git/bin"

# ========= MY EXAMPLE =============
# My Example:
# Add the oh-my-posh executable to our $PATH in bash so it properly recognizes the 'oh-my-posh' command. To verify oh-my-posh command is working run command 'oh-my-posh version'
# export PATH="$PATH:/c/Users/Syed/AppData/Local/Programs/oh-my-posh/bin"
# ===================================

# Sets default editor files as VS Code
export EDITOR="code --wait"
export KUBE_EDITOR="code --wait"

# Git Vars
# export GIT_AUTHOR_NAME="Your Name"
# export GIT_AUTHOR_EMAIL="your_email@example.com"

# Config File Vars
export KUBECONFIG=~/.kube/config

# Project Specific Paths
#export PROJECT_DIR="/path/to/your/project"
#alias cdproject="cd $PROJECT_DIR"

# FILEPATHS TO QUICKLY CHANGE BETWEEN
# For fullstack.react.net.app Devops. To use just do cd $devops
export devops="/c/Users/Syed/Documents/@MAIN_WORKSPACE/@REPOS/@APPS/fullstack/Fullstack.React.NET.App/DevOps"
# For fullstack.react.net.app k8s folder. Ex: cd $k8s
export k8s="/c/Users/Syed/Documents/@MAIN_WORKSPACE/@REPOS/@APPS/fullstack/Fullstack.React.NET.App/DevOps/k8s"
