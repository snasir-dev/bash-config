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