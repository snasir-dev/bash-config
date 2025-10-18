#!/bin/bash

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
    output=$("$@")
    exit_code=$?

    # Check if the command was successful AND produced output.
    if [[ $exit_code -eq 0 && -n "$output" ]]; then
        # Send the captured output to the clipboard.
        echo -n "$output" | clip

        # Prepare a display version of the output, truncated if needed.
        local display_output
        local max_length=500 # Maximum length for display output
        if [[ ${#output} -gt $max_length ]]; then
            display_output="${output:0:$max_length}..."
        else
            display_output="$output"
        fi

        # --- Explanation of the Original printf command ---
        # printf "✅ Command: '%s'\n📋 Copied:  \"%s\"\n" "$*" "$display_output"
        #
        # printf            -> The command to print formatted text.
        # "..."             -> The format string defining the output template.
        # %s                -> A placeholder for a string argument.
        # \n                -> A newline character.
        # \"                -> An escaped double-quote, which prints a literal " character.
        # "$*"              -> The first argument to printf (matches first %s): all function arguments as a single string (e.g., "ls -la").
        # "$display_output" -> The second argument (matches second %s): the variable containing the command's output.

        # Print formatted detailed success message. (%s indicates where the variable passed will be inserted)
        printf "📋 Command Copied: '%s'\n========= OUTPUT COPIED =========\n%s\n" "$*" "$display_output"
        # printf "✅ Command: '%s'\n📋 Copied:  \"%s\"\n" "$*" "$display_output"
        echo "========= OUTPUT END ========="

    elif [[ $exit_code -eq 0 ]]; then
        # Handle case where command ran but had no output.
        echo "✅ Command '$*' ran successfully but produced no output."
    else
        # Handle command failure.
        echo "❌ Error: Command '$*' failed or could not be found."
    fi
}
