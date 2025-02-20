# ALIASES - Command Aliases and Shortcuts
#*******************************
# ls commands
alias ll="ls -la" # Alias to list files in long format, including hidden files
alias la="ls -A" # Alias to list all files, including hidden ones
alias l="ls -CF" # Alias to list files in a multi-column format with file type indicators

# List files with detailed info, sorted by size
alias ls-size='du -sh * | sort -rh'
# Count files in current directory and subdirectories
alias filecount='find . -type f | wc -l'

# Visual File Directory - Tree like strucutre
# Official "tree" command with git-bash.
alias tree='tree.com'
# Tree-like view including hidden files
# Below mimics tree functionality.
# Basic tree-like directory structure (excluding hidden files)
alias tree2='find . -maxdepth 2 -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
alias treeall='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# Will run filetree shell method below. Remember after ft can specify parameters: ft 1 . true
alias ft="filetree"

#*******************************
# Git Aliases

alias gs="git status"
# alias ga="git add"
# alias gc="git commit -m"
# alias gp="git push"
alias gl="git log --oneline --graph --decorate --all"

# Alias for LazyGit - A Terminal User Interface for GIT
alias lg="lazygit"

#*******************************
# Kubernetes Aliases
alias k="kubectl"
alias kga="k get all,endpoints,ingress,pv,pvc,cm,secrets,nodes -o wide"
# Get Current Active Namespace
alias "kgns"="kubectl config view --minify | grep namespace"
#alias kga-<your-name-space>="k get all,pv,pvc,cm,secrets,nodes -n <namespace-name> -o wide"
# alias kctx="kubectl config use-context"
# alias kns="kubectl config set-context --current --namespace"

# Note - must have script kube-info.sh in the scripts directory to run this alias.
alias kube-info="~/.bash/scripts/kube-info.sh"

#*******************************
# grep + Search Aliases
# alias grep="grep --color=auto"
# alias fgrep="fgrep --color=auto"
# alias egrep="egrep --color=auto"
# alias findtxt="find . -type f -name '*.txt'"

#*******************************
# Source Alias
alias src="source ~/.bashrc"
alias reload="source ~/.bashrc"
