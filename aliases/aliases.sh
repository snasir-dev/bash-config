#!/bin/bash
# ALIASES - Command Aliases and Shortcuts
#**************************************************************

#====================================================================
# FILE INFORMATION & LISTING & DIRECTORY NAVIGATION ALIASES         #
#====================================================================
# ls commands
alias ll="ls -la"                                                    # Alias to list files in long format, including hidden files
alias la="ls -A"                                                     # Alias to list all files, including hidden ones
alias l="ls -CF"                                                     # Alias to list files in a multi-column format with file type indicators
alias lr='ls -R --color=auto -F -I "node_modules" -I "bin" -I "obj"' # Recursively list all files with colors and file type indicators, ignoring common build/dependency folders (node_modules, bin, obj)

# List files with detailed info, sorted by size
alias ls-size='du -sh * | sort -rh'
# Count files in current directory and subdirectories
alias filecount='find . -type f | wc -l'

# Show file type for a given file or directory. Uses 'file' command.
alias typeof='file'

#====================================================================
# DIRECTORY NAVIGATION ALIASES
# Aliases to make moving around the filesystem faster and easier.
#====================================================================

# Go back to the previous directory. Very fast for going back and forth.
alias back='cd -' # Use 'back' to return to the last directory you were in.

# Stack-based directory navigation. Useful for jumping around and returning to previous locations.
# `pushd`, `popd`, `dirs` (Aliases 'push', 'pop', 'listd'): Stack-based navigation.
#    - 'push [directory]':  Changes to [directory] and remembers the previous directory. Adds [directory] to the stack.
#    - 'pop':  Returns to the last directory you 'pushd' from.  Removes the top location from the stack.
#    - 'dirs' (or 'listd'): Shows the stack of directories you've 'pushd' into.  Numbering helps visualize the stack.
#    Example:
#    push /tmp  # Go to /tmp, remember current location
#    push /var  # Go to /var, remember /tmp
#    dirs       # Shows stack, e.g., 0 /var 1 /tmp ...
#    pop        # Go back to /tmp
#    pop        # Go back to original location before 'push /tmp'
#alias push='pushd' # Use the push function specified in functions/general-functions.sh.
alias pop='popd_at_index' # Return to the directory at the top of the stack (undoes 'pushd'). Calls popd_at_index function in general-functions.sh.
alias dirs='dirs -v'      # View the directory stack with index numbers. Useful to see where you've been with 'pushd'.
alias listd='dirs -v'     # Alternative name for 'dirs -v' - list directory stack

# Shorter aliases for common directory locations.
alias home='cd ~' # Go directly to your home directory.

# WORKSPACE_DIR=~/Documents/@MAIN_WORKSPACE # Cannot use quotes, will treat "~" as literal string. No Quotes or using $HOME env variable works.
# Prefix going to specific directories with "." Use ".." to open directories with git repositories initialized.
# Easy navigation to directories that are not git repositories. Prefix with '.'
WORKSPACE_DIR="$HOME/Documents/@MAIN_WORKSPACE"
alias ".main_workspace"='cd $WORKSPACE_DIR' # Go to my Main Workspace. Just type '.workspace' to go there.
alias ".repos"='cd $WORKSPACE_DIR/@REPOS'
alias ".apps"='cd $WORKSPACE_DIR/@REPOS/@APPS'

# Prefix aliases opening repositories with ".."
alias "..fullstack-react-net-app__REPO"='cd $WORKSPACE_DIR/@REPOS/@APPS/fullstack/Fullstack.React.NET.App'
alias "..shared-resources-repo__REPO"='cd $WORKSPACE_DIR/@REPOS/@SHARED_RESOURCES_REPO'
alias "..bash__REPO"='cd ~/.bash'
alias "..orbz-cli__REPO"='cd $WORKSPACE_DIR/@REPOS/SHELLS_AND_CLI_TOOLS/CLI_TOOLS/orbz-cli'

# Visual File Directory - Tree like structure
# Official "tree" command with git-bash.
alias tree='tree.com'
# Tree-like view including hidden files
# Below mimics tree functionality.
# Basic tree-like directory structure (excluding hidden files)
alias tree2='find . -maxdepth 2 -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
alias treeall='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# (IMPORTANT) Filetree - Custom function to display a tree-like structure of files and directories.
# Will run filetree shell method below. Remember after ft can specify parameters:
# Example: ft 3 false ~/Documents/@MAIN_WORKSPACE
alias ft="filetree"

#==============================================================================
# COMMAND SHORTCUTS & UTILITIES ALIASES
# Aliases for frequently used commands or to add extra functionality.
#==============================================================================

alias mkdir='mkdir -p' # Create directories recursively (including parent directories if they don't exist). Very convenient for nested directories.
# alias mkd='mkdir -p'  # Shorter version for 'mkdir -p'.

alias rm='rm -i' # Interactive remove - prompts before deleting files. Prevents accidental deletion, especially with 'rm -rf'.
alias rmi='rm -i'

alias cp='cp -i -r'  # Interactive copy - prompts before overwriting files.  Prevents accidental overwrites. -r: Recursive mode (needed for copying directories).
alias cpi='cp -i -r' # Shorter version for interactive copy.

alias mv='mv -i'  # Interactive move - prompts before overwriting files. Prevents accidental overwrites during moves.
alias mvi='mv -i' # Shorter version for interactive move.

alias grep='grep --color=auto' # Grep with color highlighting.  Makes grep output much easier to read.
# alias g='grep --color=auto'    # Shorter alias for colorized grep.

#******************************
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
# alias src="source ~/.bashrc"
# alias reload="source ~/.bashrc"
# alias refresh="source ~/.bashrc"
# alias r="source ~/.bashrc"

# Function to reload the shell, with an option for setting debug output
# Optionally takes a single argument: 'true' to enable debug output. If no value is provided, defaults to 'false'.
# Usage: reload_shell [-d|--d|--debug|--verbose|true]

reload_shell() {
  local arg="$1"

  # Default to DEBUG=true, unless we specify any of these arguments (false, -s, --silent, -q, --quiet)
  case "$arg" in
    # If the argument matches any of these "off" patterns, disable debug mode.
    false|-s|--silent|-q|--quiet)
      export DEBUG=false
      ;;
    # For any other argument, OR if NO argument is provided, enable debug mode.
    *)  
       # echo "🐞🐞🐞 Debug mode enabled. Sourcing ~/.bashrc... 🐞🐞🐞"
      export DEBUG=true
      ;;
  esac

  # INVERSE CONDITION ABOVE. Since we want to enable debug mode by default, we are providing silent flags instead of debug flags. Belows is reference to reverse the logic.
  # Match any of the debug-like inputs (-d, --d, -debug, --debug, -v, --verbose, true)
  # If any of these are provided, enable debug mode.
  # case "$arg" in
  #   -d|--d|-debug|--debug|-v|--verbose|true)
  #     # echo "🐞🐞🐞 Debug mode enabled. Sourcing ~/.bashrc... 🐞🐞🐞"

  #     export DEBUG=true
  #     ;;
  #   *)
  #     export DEBUG=false
  #     ;;
  # esac

  # Source the .bashrc file to apply changes
  source ~/.bashrc

  # Unset DEBUG after sourcing to clean up the environment
  unset DEBUG
}



# shellcheck disable=SC2139
# Brace expansion {src,reload,refresh,r} generates four separate aliases (src, reload, refresh, r) in a single command. Bash processes this during startup with no runtime performance difference
# alias {src,reload,refresh,r}="source ~/.bashrc"  # NORMALLY HOW WE SOURCE .bashrc
alias {src,reload,refresh,r}="reload_shell" # Use the reload_shell function to source .bashrc with options