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
  if [ -z "$1" ]; then  # Check if no argument is provided ($1 is empty)
    pushd .  # Push the current directory (.) onto the stack
  else
    pushd "$@" # If arguments are provided, pass them to the original pushd command
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
    for ((i=1; i<=levels; i++)); do
      path="../${path}"
    done
    cd "$path"
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
    if dirs | grep -q .; then  # Check if directory stack is not empty (grep for any line)
      popd 2>/dev/null # Standard popd - pop top and cd. Suppress stderr in case stack becomes empty.
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
    echo -e "\n" # Add a newline for readability
    echo -e "\033[1;34mUpdated Stack:\033[0m" # Print 'Updated Stack:' in bold blue
    echo -e "----------------------------------------"
    dirs -v # View the directory stack with index numbers.
    return 0 # Successful execution for popd_at_index with index
  fi
}



#=======================
# Allows me to dynamically jump between directories within my current filepath. For example in ~/Documents/@MAIN-WORKSPACE. just do "j <dirname>" so "j manifests" or any directory name "j @main-workspace", if it exists within @MAIN-WORKSPACE will try to go to it. Also added autocompletion.
# Create an associative array to store path mappings
declare -A path_mappings

# Function to update path mappings
update_path_mappings() {
    local current_path="$PWD"
    local path_parts
    
    # Split the path into parts
    IFS='/' read -ra path_parts <<< "$current_path"
    
    # Clear existing mappings
    path_mappings=()
    
    # Build the path progressively and add mappings
    local built_path=""
    for part in "${path_parts[@]}"; do
        if [[ -n $part ]]; then
            built_path="$built_path/$part"
            # Store both lowercase and actual name mappings
            path_mappings[${part,,}]="$built_path"
            path_mappings[$part]="$built_path"
        fi
    done
}

# Function to jump to directory - To use do j <any-directory-within-filepath> "j @main-workspace" etc
j() {
    if [ -z "$1" ]; then
        echo "Usage: j <directory_name>"
        return 1
    fi
    
    # Update mappings based on current directory
    update_path_mappings
    
    # Convert input to lowercase for case-insensitive matching
    local search=${1,,}
    
    if [ -n "${path_mappings[$1]}" ]; then
        cd "${path_mappings[$1]}"
    elif [ -n "${path_mappings[$search]}" ]; then
        cd "${path_mappings[$search]}"
    else
        echo "No matching directory found for: $1"
        return 1
    fi
}

# Add tab completion for j (jump) complete. 
_j_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    update_path_mappings
    COMPREPLY=($(compgen -W "${!path_mappings[*]}" -- "$cur"))
}

complete -F _j_complete j
# End j (jump)
#=======================