#!/bin/bash
# ENV VARIABLES
#*******************************

# Important:
# All XDG Compliant Tools will set the following directory as their home. (Lazygit, Thef***, etc.)
export XDG_CONFIG_HOME="$HOME/.config"

# ======= SYMLINKS =======
# Following allows the create symlink files to work properly in WINDOWS: 'ln -s ORIGINAL-FILE LINK-FILE'
# Note - to create SYMLINK Directories in windows, do command 'ln -s ORIGINAL-DIR LINK-DIR'.
# To Properly work in WINDOWS for GIT BASH and so we don't have to prefix 'MSYS=winsymlinks:nativestrict' before the ABOVE COMMANDS EVERY TIME. Now you can run above commands normally.
# setting this variable makes Git Bash's ln -s command behave exactly like PowerShell's New-Item or cmd's mklink, creating links that are understood by every application on Windows
export MSYS="winsymlinks:nativestrict"

# USE CASE OF ENV VARIABLES. Do $VARIABLE_NAME to TRIGGER
# Ex: cd $devops -> Goes to devops
# Ex2: cd $k8s -> Goes to k8s folder specified below.

# Sets default editor files as VS CODE
export EDITOR="code --wait"
export KUBE_EDITOR="code --wait"

# Git Vars
# export GIT_AUTHOR_NAME="Your Name"
# export GIT_AUTHOR_EMAIL="your_email@example.com"

# Config File Varsx
export KUBECONFIG=~/.kube/config

# Project Specific Paths
#export PROJECT_DIR="/path/to/your/project"
#alias cdproject="cd $PROJECT_DIR"

# FILEPATHS TO QUICKLY CHANGE BETWEEN
# Note, have a default file path "$HOME" which goes to home directory. Can put it in file paths
#   - Example: cd $HOME/.config

# For fullstack.react.net.app Devops. To use just do cd $devops
export devops="/c/Users/Syed/Documents/@MAIN_WORKSPACE/@REPOS/@APPS/fullstack/Fullstack.React.NET.App/DevOps"
# For fullstack.react.net.app k8s folder. Ex: cd $k8s
export k8s="/c/Users/Syed/Documents/@MAIN_WORKSPACE/@REPOS/@APPS/fullstack/Fullstack.React.NET.App/DevOps/k8s"
