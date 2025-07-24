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


# Convert Unix path to Windows path with backslashes
# Usable in File Explorer (e.g., C:\Users\...)
pwdw() {
    # Convert 'pwd' output via stdin; '--file -' tells cygpath to read paths from stdins
    pwd | cygpath -w --file -  
}

# Optional alias-style wrapper for backslash version
# Wrapper function for pwdw (same as pwdw)
# Defined as a function (not alias) so it can be passed to other functions like: copy pwdwb
pwdwb() {
    pwdw
}

# Convert Unix path to Windows path with FORWARD slashes
# More readable (e.g., C:/Users/...), but NOT accepted in File Explorer
pwdwf() {
    pwd | cygpath -m --file -  # '-m' gives FORWARD slashes; '--file -' reads piped input (from 'pwd') via stdin
}


# Function to execute a command (including aliases) and copy its stdout
copy() {

    # Executes all arguments passed to the function as a single command
    # and pipes the output to clip.
    if "$@" | clip; then
        # Command Success Message.
        echo "📋 Output of '$*' copied to clipboard. 📋"
    else
        # Error Message.
        echo "❌ Error: Command '$*' failed or could not be found."
    fi
}



# Function prints out both the command and its output (up to 50 characters)
copy_detailed() {
    local output
    local exit_code

    # Capture the command's standard output into a variable.
    # We also capture its exit code to check for success or failure.
    output=$( "$@" )
    exit_code=$?

    # Check if the command was successful AND produced output.
    if [[ $exit_code -eq 0 && -n "$output" ]]; then
        # Send the captured output to the clipboard.
        echo -n "$output" | clip

        # Prepare a display version of the output, truncated if needed.
        local display_output
        if [[ ${#output} -gt 50 ]]; then
            display_output="${output:0:50}..."
        else
            display_output="$output"
        fi

        # Print the new, detailed success message using printf for clean formatting.
        printf "✅ Command: '%s'\n📋 Copied:  \"%s\"\n" "$*" "$display_output"

    elif [[ $exit_code -eq 0 ]]; then
        # Handle case where command ran but had no output.
        echo "✅ Command '$*' ran successfully but produced no output."
    else
        # Handle command failure.
        echo "❌ Error: Command '$*' failed or could not be found."
    fi
}