#!/bin/bash
# ENV VARIABLES
#*******************************

# USE CASE OF ENV VARIABLES. Do $VARIABLE_NAME to TRIGGER
# Ex: cd $devops -> Goes to devops
# Ex2: cd $k8s -> Goes to k8s folder specified below.

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
