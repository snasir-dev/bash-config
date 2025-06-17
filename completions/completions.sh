#!/bin/bash
#=======================================
# BASH GENERAL AUTO COMPLETION SCRIPTS #
#=======================================

# This section enables general bash completion features.
# Bash completion allows the shell to suggest and auto-complete commands and options.
# For example, typing 'kubectl ge<TAB>' can auto-complete to 'kubectl get'.
# The completion script is usually stored in '/usr/share/bash-completion/bash_completion'.

# General bash-completion script for common commands (e.g., kubectl, Git)
# Download by running following bash command:
#OLD: curl -o ~/.bash_completion https://raw.githubusercontent.com/scop/bash-completion/master/bash_completion
# curl -L https://raw.githubusercontent.com/scop/bash-completion/master/bash_completion -o ~/.bash_completion
if [ -f ~/.bash/completions/third-party/.bash_completion ]; then
    source ~/.bash/completions/third-party/.bash_completion
else
    echo "Bash completion file not found. Please make sure the file is located at ~/.bash/completions/third-party/.bash_completion"
fi

#=======================================
# Kubectl Auto-Completion SCRIPTS      #
#=======================================
# Check if `kubectl` command exists by using `command -v kubectl`.
# `command -v` checks if `kubectl` is available, and `&> /dev/null` discards output.
# If `kubectl` is found, the following commands will be executed.
if command -v kubectl &>/dev/null; then

    # Load the bash completion script for `kubectl` if it exists.
    # `kubectl completion bash` outputs a completion script for bash.
    # `source <(...)` immediately loads this script into the shell session.
    source <(kubectl completion bash)

    # Create an alias `k` for the `kubectl` command.
    # This makes it faster to type, as `k` will work the same as `kubectl`.
    alias k=kubectl

    # Enable auto-completion for the `k` alias, so that 'k' behaves like 'kubectl' in terms of auto-completion.
    # `-o default` allows normal bash completion to apply if `kubectl`'s completion is not defined.
    # `-F __start_kubectl` specifies the function to handle the completion for `k`.
    complete -o default -F __start_kubectl k
fi

#=======================================
# Minikube Auto-Completion SCRIPTS     #
#=======================================
# Prerequisite - Ensure bash-completion is already installed.
# Can install on Windows with command: choco install bash-completion
source <(minikube completion bash)

#=========================================
# DOCKER CLI Auto-Completion SCRIPTS     #
#=========================================
# Enable Docker CLI auto-completion (including Docker Compose v2 - "docker compose" not "docker-compose" which is v1).
# This command dynamically generates the auto-completion script for Docker commands.
# When you type a command like 'docker ru<TAB>', it auto-completes to 'docker run', and similarly for Docker Compose commands 'docker compose exec <will provide all service names running>'.
# The command 'docker completion bash' outputs a Bash script that defines completions for Docker commands. When you wrap it with eval "$( ... )", the shell immediately evaluates the script and loads the completions
#eval "$(docker completion bash)" - Eval command might run into security risks, complex scripts might cause quoting issues, and are less efficient for running scripts than source command.
source <(docker completion bash)

#=============================================================
# Helm (Kubernetes Package Manager) Auto-Completion SCRIPTS  #
#=============================================================
# Official Helm Docs for Helm Completion: https://helm.sh/docs/helm/helm_completion/
# Enable Helm CLI auto-completion.
# `helm completion bash` outputs a bash script for helm command completions.
# Using `source <(...)` loads and executes this script in your current shell.
# Pre-requisite - Ensure Helm is installed on your system.
# Can install on Windows with command: choco install kubernetes-helm
if command -v helm &>/dev/null; then
    source <(helm completion bash)
fi

#=================================================
# Argo CD Auto-Completion SCRIPTS                #
#=================================================
# Official Argo CD Documentation: https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_completion/
# Enable Argo CD CLI auto-completion for bash.
# The `argocd completion bash` command generates completion script for Argo CD CLI commands.
# Using `source <(...)` loads these completions directly into your current shell session.
# This enables tab completion for argocd commands, subcommands, and available options.
# Pre-requisite - Ensure Argo CD CLI is installed and available in PATH.
# Can install on Windows with command: choco install argocd-cli
if command -v argocd &>/dev/null; then
    source <(argocd completion bash)
fi

#===============================================
# GitHub CLI (gh) Auto-Completion SCRIPTS      #
#===============================================
# Official GitHub CLI Completion Docs: https://cli.github.com/manual/gh_completion
# Enable GitHub CLI auto-completion for bash.
# `gh completion -s bash` generates completion script for gh CLI.
# Using `source <(...)` loads completions into the current shell session.
# This enables tab completion for `gh` commands, subcommands, and flags like `--state`, `--label`, etc.
# Pre-requisite - Ensure GitHub CLI is installed and available in PATH.
# Can install on Windows with command: winget install --id GitHub.cli
if command -v gh &>/dev/null; then
    source <(gh completion -s bash)
    # eval "$(gh completion -s bash)"
fi

#=================================================
# Terraform Auto-Completion SCRIPTS              #
#=================================================
# Official Terraform Documentation: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#enable-tab-completion
# Also See: https://developer.hashicorp.com/terraform/cli/commands#shell-tab-completion

# The `terraform -install-autocomplete` command would normally add the following to .bashrc:
# complete -C C:\ProgramData\chocolatey\lib\terraform\tools\terraform.exe terraform.exe
# However, this Windows-style path format doesn't work properly in bash on Windows.
#
# To fix this, we need to:
# 1. Get the correct path format using: 'which terraform'
# 2. Update the complete command to use Unix-style path format
# 3. Remove the .exe extension from the command name (use 'terraform' not 'terraform.exe')
# Final command would look as follows: complete -C /c/ProgramData/chocolatey/bin/terraform.exe terraform
#
# This enables tab completion for terraform commands, subcommands, and available options.
# Pre-requisite - Ensure Terraform is installed and available in PATH.
# Can install on Windows with command: choco install terraform
if command -v terraform &>/dev/null; then
    # Note this path is specific to Chocolatey installation on Windows.
    complete -C /c/ProgramData/chocolatey/bin/terraform.exe terraform
fi
