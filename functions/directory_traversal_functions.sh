#!/bin/bash
#===============================================================
# EASIER DIRECTORY TRAVERSAL                                  #
#===============================================================

# Allows us to use the pushd function without specifying the directory.
# If no argument is provided, it pushes the current directory onto the stack.
# Example:
# cd /home/user/projects/TEST # Start in TEST
# push     # Remember path /home/user/projects/TEST
# up 2     # Go up two levels to /home/user
# back     # Go back to /home/user/projects/TEST (note - back is an alias for 'cd -')
# cd /tmp  # Go to /tmp
# pop      # Return to the directory you pushed. Back in /home/user/projects/TEST
# dirs -v  # Check the directory stack (should be fewer entries now)

push() {
  if [ -z "$1" ]; then # Check if no argument is provided ($1 is empty)
    pushd .            # Push the current directory (.) onto the stack
  else
    pushd "$@" || exit # If arguments are provided, pass them to the original pushd command
  fi
}

# `up [n]` function:  Go up a specific number of directory levels.
# Usage: up [number]  (e.g., 'up 2' goes up two levels)
#    - `up`: Goes up one level (same as 'cd ..').
#    - `up 2`: Goes up two levels (same as 'cd ../..', or '...').
#    - `up 3`: Goes up three levels (same as 'cd ../../..', or '....').
#    - `up 4`, `up 5`, etc.:  Continue going up more levels as needed.  Much cleaner than typing many '../' manually.
up() {
  if [ -z "$1" ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    cd .. # If no argument or not a number, go up one level
  else
    levels=$1
    path=""
    for ((i = 1; i <= levels; i++)); do
      path="../${path}"
    done
    cd "$path" || exit
  fi
}

# Function: popd_at_index [<index>]

# Usage Examples:
# 1. View stack: dirs -v
# 2. Standard popd: popd_at_index
# 3. Go to index 2: popd_at_index 2
# replace popd_at_index with pop if aliased.
popd_at_index() {
  local index=$1

  # Scenario 1: No index provided (standard popd behavior)
  if [[ -z "$index" ]]; then
    # Perform standard popd action if stack is not empty
    if dirs | grep -q .; then # Check if directory stack is not empty (grep for any line)
      popd 2>/dev/null        # Standard popd - pop top and cd. Suppress stderr in case stack becomes empty.
      echo "Performed standard popd (top of stack)."
      dirs -v # Optional: Show updated stack
    else
      echo "Directory stack is empty. Cannot perform standard popd."
    fi
    return 0 # Successful execution for standard popd case

  # Scenario 2: Index is provided (original popd_at_index + index behavior)
  else
    # Check if the provided index is a non-negative integer
    if ! [[ "$index" =~ ^[0-9]+$ ]]; then
      echo "Usage: popd_at_index [<index>]"
      echo "  <index> (optional) should be a non-negative integer representing the stack position (starting from 0)."
      echo "  If no index is provided, performs standard popd (top of stack)."
      return 1 # Error: Invalid index format
    fi

    # Get the directory stack and extract the path at the specified index
    # local path=$(dirs -v | awk -v idx="$index" '$1 == idx {print $2}')
    # Get the directory stack and extract the path at the specified index
    local path_with_tilde=$(dirs -v | awk -v idx="$index" '$1 == idx {print $2}')

    # Replace ~ with $HOME in the path
    local path="${path_with_tilde/#\~/$HOME}"
    # echo "Debug Path with tilde: $path_with_tilde"
    # echo "Debug Path at index $index: $path"
    # echo "Debug Path: \"$path\""  # Print path enclosed in double quotes

    # Check if the index was valid and a path was found
    if [[ -z "$path" ]]; then
      echo "Error: Index '$index' is out of range or directory stack is empty."
      return 1 # Error: Index out of range
    fi

    # Change the current directory to the path at the specified index
    if cd "$path"; then
      echo "Changed directory to: $path (index $index)"
    else
      echo "Error: Failed to change directory to: $path (index $index)"
      return 1 # Error: cd failed
    fi

    # Remove the directory at the specified index from the stack using popd +index
    # TODO: fix an issue where it is not properly removing the correct index from the stack.
    popd "+$index" 2>/dev/null # Suppress stderr

    # Show the updated directory stack
    echo -e "\n"                              # Add a newline for readability
    echo -e "\033[1;34mUpdated Stack:\033[0m" # Print 'Updated Stack:' in bold blue
    echo -e "----------------------------------------"
    dirs -v  # View the directory stack with index numbers.
    return 0 # Successful execution for popd_at_index with index
  fi
}

# ==============================================================================
# Dynamic Jump (j)

# Allows me to dynamically jump between directories within my current filepath.
# For example in ~/Documents/@MAIN-WORKSPACE. just do "j <dirname>" so "j manifests" or any directory name "j @main-workspace", if it exists within @MAIN-WORKSPACE will try to go to it. Also added autocompletion. Can do "j <tab>" to see available directories to jump to.

# Create an associative array to store path mappings
#
# Jumps to a parent directory within the current file path.
# Works dynamically with any directory you are in.
#
# EXAMPLE:
# If you are in: /c/Users/Syed/Documents/Work/ProjectA/src
# Running 'j Documents' will take you to: /c/Users/Syed/Documents
# ===============

# Declare a global associative array.
# An associative array lets us store key-value pairs (e.g., 'Documents' -> '/c/Users/Documents').
# It must be global ('-gA') so that all functions, including the separate
# autocompletion function, can access and share the same data.
declare -gA j_path_mappings

# Defines a helper function that parses the current path and builds the map of
# directory names to their full paths.
# It's a separate function so it can be reused by both the main `j` command
# and the `_j_complete` function without duplicating code.
_j_update_path_mappings() {
  # Clear the array at the start to ensure we're always working with fresh data
  # from the current directory, not a previous one.
  j_path_mappings=()

  # Store the current working directory ('$PWD') in a local variable.
  local current_path="$PWD"
  # Declare other local variables to be used within this function's scope.
  local path_parts
  local built_path="" # This will be built up, piece by piece.

  # This is the core parsing step.
  # - 'IFS="/"': Temporarily sets the Internal Field Separator to '/'.
  # - 'read -ra path_parts': Reads the '$current_path' string, splits it by the
  #   'IFS', and stores the resulting pieces in an array named 'path_parts'.
  IFS='/' read -ra path_parts <<<"$current_path"

  # Loop through each directory name that was extracted into the 'path_parts' array.
  for part in "${path_parts[@]}"; do
    # '[[ -n "$part" ]]': Proceed only if the 'part' is not an empty string. This
    # handles the empty element created by a leading '/' in the path.
    if [[ -n "$part" ]]; then
      # This block handles a specific edge case for Git Bash on Windows where
      # the root of a path like '/c/Users' is just a single letter.
      if [[ -z "$built_path" && ${#part} -eq 1 ]]; then
        built_path="/$part" # Start the path with '/c'
      else
        built_path="$built_path/$part" # Append the next part, e.g., '/c/Users'
      fi

      # This is the key to making the command work. We create two entries in our map:
      # 1. The original case: j_path_mappings["Documents"] = "/c/Users/Documents"
      # 2. The lowercase version: j_path_mappings["documents"] = "/c/Users/Documents"
      # This allows for case-insensitive matching later on.
      # Note: If a name appears twice in a path, this logic will map to the deepest one.
      j_path_mappings["$part"]="$built_path"
      j_path_mappings["${part,,}"]="$built_path" # '${part,,}' is a bashism for lowercase
    fi
  done
}

# THE MAIN `j` COMMAND
# This is the main function that is executed when you type `j <something>`.
j() {
  # STEP 1: Always refresh the path map based on the current location first.
  _j_update_path_mappings

  # STEP 2: Handle the case where the user just types `j` with no arguments.
  # '[[ -z "$1" ]]': Checks if the first argument ('$1') is zero-length (empty).
  if [[ -z "$1" ]]; then
    echo "Usage: j <parent_directory_name>"
    echo "Available jump points from your current path:"

    # This pipeline gets all directory names from our map, sorts them, and removes
    # case-insensitive duplicates to create a clean list for the user.
    for key in $(printf "%s\n" "${!j_path_mappings[@]}" | sort | uniq -i); do
      # 'printf' is used here for clean, aligned formatting of the output.
      printf "  %-25s -> %s\n" "$key" "${j_path_mappings[$key]}"
    done
    return 1 # Exit the function with an error code.
  fi

  # Store the user's input in variables for easy access.
  local search_term_orig="$1"
  local search_term_lower="${1,,}" # The lowercase version of the input.

  # STEP 3: Find the path and change directory.
  # '[[ -v "key" ]]': This is the correct way to check if a key *exists*
  # in an associative array.
  # We check for the original case first.
  if [[ -v "j_path_mappings[$search_term_orig]" ]]; then
    cd "${j_path_mappings[$search_term_orig]}"
  # If the original case fails, we check for the lowercase version.
  elif [[ -v "j_path_mappings[$search_term_lower]" ]]; then
    cd "${j_path_mappings[$search_term_lower]}"
  # If neither key exists, inform the user and exit.
  else
    echo "❌ Error: Directory '$search_term_orig' not found in your current path."
    return 1
  fi
}

# # Autocompletion function for 'j'. This will PROPERLY show tab completion for directories. No more duplicates. But instead, you must type the correct case for it to auto complete. For example for path '/c/Users/Syed/Documents/@MAIN-WORKSPACE' if we do "j u" will not work must do "j U" and it will auto complete to "j User" and will go there.
# # This function provides the logic for tab completion.
# # It is automatically called by Bash when you press Tab after typing `j `.
# # This version creates a clean list of completions without duplicates.
# _j_complete() {
#   # 'COMP_WORDS' is a Bash array holding the words on the current command line.
#   # 'COMP_CWORD' is the index of the word the cursor is currently on.
#   # 'cur' will therefore hold the word we are trying to complete (e.g., "Doc").
#   local cur="${COMP_WORDS[COMP_CWORD]}"
#   local path_parts
#   local unique_completions

#   # As before, we split the current path into its component parts.
#   IFS='/' read -ra path_parts <<<"$PWD"

#   # This pipeline generates a clean list of unique directory names for completion.
#   # - 'printf "%s\n"': Prints each array element on a new line.
#   # - 'grep .': Removes any blank lines from the output.
#   # - 'sort -u': Sorts the lines and removes duplicates, leaving original casing.
#   # 'mapfile -t ... < <(...)': Reads this clean output into the 'unique_completions' array.
#   mapfile -t unique_completions < <(printf "%s\n" "${path_parts[@]}" | grep . | sort -u)

#   # 'COMPREPLY' is the special Bash array that holds the possible completion suggestions.
#   # 'compgen -W "..." -- "$cur"': This command tells Bash to generate completions
#   # from the Word list ('-W') provided, based on the current word ('$cur').
#   COMPREPLY=($(compgen -W "${unique_completions[*]}" -- "$cur"))
# }

# BASH AUTOCOMPLETION SETUP for "j()"
# Autocompletion function for 'j'. This give yous ability to tab complete REGARDLESS of the case-sensitivity of the directory names. if you have '/c/Users/Syed/Documents/@MAIN-WORKSPACE' can do "j u" and it will auto complete "j user" and will go there.
# Minor downside is when you see tab results, it will show duplicates due to case-sensitivity but convenience outweighs the negative.

# This function provides the logic for Bash's programmable tab completion.
# It is automatically triggered by Bash when you press the Tab key after
# typing the `j` command. This version enables case-insensitive completion
# at the cost of showing duplicate suggestions in the list.
_j_complete() {
  # First, call the helper function to parse the current directory (`$PWD`) and
  # populate the `j_path_mappings` associative array. This ensures the
  # completion suggestions are always relevant to your current location.
  _j_update_path_mappings

  # Bash provides special variables for completion functions.
  # - `COMP_WORDS`: An array containing all individual words on the current command line.
  # - `COMP_CWORD`: The index number of the word the cursor is currently on.
  # This line gets the word you are currently trying to complete (e.g., "Doc").
  local cur="${COMP_WORDS[COMP_CWORD]}"

  # This is the final command that generates and assigns the suggestions.
  # - `COMPREPLY`: The special array variable that Bash uses to display completion options.
  # - `compgen -W "..."`: A Bash built-in that generates completions from a given Word list (`-W`).
  # - `${!j_path_mappings[*]}`: This expands to a list of all *keys* in our associative array.
  #   Since our map contains both "Documents" and "documents", both are included in this list.
  # - `-- "$cur"`: This tells `compgen` to only suggest words from the list that start
  #   with the current word under the cursor.
  COMPREPLY=($(compgen -W "${!j_path_mappings[*]}" -- "$cur"))
}

# Register the completion function to work with the 'j' command.
complete -F _j_complete j

# End of j (jump) function and autocompletion setup.
# ==============================================================================
