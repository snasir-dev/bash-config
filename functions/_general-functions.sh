#!/bin/bash
# Contains all bash general/common function definitions

# List largest files (top 10 by default, customizable). Example:  largest 5: Show top 5 largest files
largest() {
    count=${1:-10}
    find . -type f -print0 | xargs -0 du -h | sort -rh | head -n "$count"
}

# List files older than X days. Example usage: oldfiles 60: List files older than 60 days
oldfiles() {
    days=${1:-30}
    find . -type f -mtime +"$days" -print
}

# Combine file count with size information
dirsummary() {
    echo "Total Files: $(find . -type f | wc -l)"
    echo "Total Size: $(du -sh .)"
}

#==================================================================

# This defines a Bash function named print_command_output that takes one argument ($1).
# The function prints the command to be executed in bold blue color, then executes the command, and finally prints a divider.

# echo -e "\033[1;34m> $1\033[0m"

# echo -e enables interpretation of escape sequences. Allows for adding color to text or newlines ("\n").
# \033[1;34m sets text color to bold blue.
# > $1 prints the command being executed (e.g., kubectl config current-context).
# \033[0m resets the text color to default.
print_command_output() {
    echo -e "\033[1;34mCommand: $1\033[0m"               # Bold blue command
    eval "$1"                                            # eval executes the command passed as an argument ($1). Example: If we call print_command_output "kubectl config get-contexts", it runs kubectl config get-contexts.
    echo -e "\n----------------------------------------" # Divider. Using echo -e allows us to interpret escape sequences like \n for a new line.
}

# Export specific functions so child bash processes inherit them
# Note this only works for scripts with "/bin/bash" shebang. Other shells like "/bin/sh" will not have access to these functions.
export -f largest oldfiles dirsummary print_command_output
