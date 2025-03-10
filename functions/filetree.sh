#!/bin/bash
# Function to show directory structure in a tree-like format
# Will run filetree shell method below. Remember after ft can specify parameters: ft 1 . true

#alias ft="filetree"

# LATESTs
filetree() {
    # Default values
    local maxdepth="${1:-1}"      # Default depth is 1
    local filepath="${2:-.}"      # Default to the current directory
    local showhidden="${3:-true}" # Default to not showing hidden files
    local full_path
    full_path=$(readlink -f "$filepath")

    # Validate the directory
    if [ ! -d "$full_path" ]; then
        echo "Error: '$filepath' is not a valid directory."
        return 1
    fi

    # Color variables
    local color_reset="\033[0m"
    local color_dir="\033[1;33m"  # Yellow for directories
    local color_file="\033[0;37m" # White for files

    # Tree symbols
    local main_symbol="→"  # For main entries
    local sub_symbol="  ↳" # For subdirectories

    # Recursive function to list directories and files
    list_dir() {
        local current_path="$1"
        local current_depth="$2"

        # Prevent listing beyond max depth
        if [ "$current_depth" -ge "$maxdepth" ]; then
            return
        fi

        # Prepare find options
        local find_options=(-mindepth 1 -maxdepth 1)
        if [ "$showhidden" != "true" ]; then
            find_options+=(-not -path '*/.*')
        fi

        # Separate directories and files, filtering out empty/non-existent directories
        local directories
        local files

        # Get non-empty directories first (sorted)
        directories=$(find "$current_path" "${find_options[@]}" -type d | sort)

        # Get files separately (sorted)
        files=$(find "$current_path" "${find_options[@]}" -type f | sort)

        # Iterate over directories first
        while IFS= read -r entry; do
            # Check if directory is still valid
            if [ ! -d "$entry" ]; then
                continue
            fi

            local relative_path="${entry#$full_path/}"                # Remove base path
            local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

            if [ "$current_depth" -eq 0 ]; then
                echo -e "${color_dir}${main_symbol} ${relative_path}${color_reset}"
            else
                echo -e "${prefix}${color_dir}${sub_symbol} ${relative_path##*/}${color_reset}"
            fi

            # Recursively list contents of this directory if depth allows
            list_dir "$entry" $((current_depth + 1))
        done <<<"$directories"

        # Then iterate over files
        while IFS= read -r entry; do
            # Check if file is still valid
            if [ ! -f "$entry" ]; then
                continue
            fi

            local relative_path="${entry#$full_path/}"                # Remove base path
            local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

            if [ "$current_depth" -eq 0 ]; then
                echo -e "${color_file}${main_symbol} ${relative_path}${color_reset}"
            else
                echo -e "${prefix}${color_file}${sub_symbol} ${relative_path##*/}${color_reset}"
            fi
        done <<<"$files"
    }

    # Start the listing from the given path
    list_dir "$full_path" 0
}

# NOTE FOR HIDDEN DIRECTORIES, NOT SHOWING FILES.
# filetree() {
# # Default values
# local maxdepth="${1:-1}"       # Default depth is 1
# local filepath="${2:-.}"       # Default to the current directory
# local showhidden="${3:-false}" # Default to not showing hidden files
# local full_path
# full_path=$(readlink -f "$filepath")

# # Validate the directory
# if [ ! -d "$full_path" ]; then
# echo "Error: '$filepath' is not a valid directory."
# return 1
# fi

# # Color variables
# local color_reset="\033[0m"
# local color_dir="\033[1;33m"   # Yellow for directories
# local color_file="\033[0;37m"  # White for files

# # Tree symbols
# local main_symbol="→"   # For main entries
# local sub_symbol=" ↳"   # For subdirectories

# # Recursive function to list directories and files
# list_dir() {
# local current_path="$1"
# local current_depth="$2"

# # Prevent listing beyond max depth
# if [ "$current_depth" -ge "$maxdepth" ]; then
# return
# fi

# # Prepare find options
# local find_options=(-mindepth 1 -maxdepth 1)
# if [ "$showhidden" != "true" ]; then
# find_options+=(-not -path '*/.*')
# fi

# # Separate directories and files, filtering out empty/non-existent directories
# local directories
# local files

# # Get non-empty directories first (sorted)
# directories=$(find "$current_path" "${find_options[@]}" -type d -not -empty | sort)

# # Get files separately (sorted)
# files=$(find "$current_path" "${find_options[@]}" -type f | sort)

# # Iterate over directories first
# while IFS= read -r entry; do
# # Check if directory is still valid
# if [ ! -d "$entry" ]; then
# continue
# fi

# local relative_path="${entry#$full_path/}" # Remove base path
# local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

# if [ "$current_depth" -eq 0 ]; then
# echo -e "${color_dir}${main_symbol} ${relative_path}${color_reset}"
# else
# echo -e "${prefix}${color_dir}${sub_symbol} ${relative_path##*/}${color_reset}"
# fi

# # Check if directory has contents before recursing
# local dir_contents
# dir_contents=$(find "$entry" -mindepth 1 -maxdepth 1 \( -type d -o -type f \) -not -path '*/.*' 2>/dev/null)

# # Recursively list contents of this directory if depth and contents allow
# if [ -n "$dir_contents" ] && [ "$current_depth" -lt "$((maxdepth - 1))" ]; then
# list_dir "$entry" $((current_depth + 1))
# fi
# done <<< "$directories"

# # Then iterate over files
# while IFS= read -r entry; do
# # Check if file is still valid
# if [ ! -f "$entry" ]; then
# continue
# fi

# local relative_path="${entry#$full_path/}" # Remove base path
# local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

# if [ "$current_depth" -eq 0 ]; then
# echo -e "${color_file}${main_symbol} ${relative_path}${color_reset}"
# else
# echo -e "${prefix}${color_file}${sub_symbol} ${relative_path##*/}${color_reset}"
# fi
# done <<< "$files"
# }

# # Start the listing from the given path
# list_dir "$full_path" 0
# }

# OLD IMPLMENTATION 2
# GO TO IF IT DOES NOT WORK.
# filetree() {
# # Default values
# local maxdepth="${1:-1}"       # Default depth is 1
# local filepath="${2:-.}"       # Default to the current directory
# local showhidden="${3:-false}" # Default to not showing hidden files
# local full_path
# full_path=$(readlink -f "$filepath")

# # Validate the directory
# if [ ! -d "$full_path" ]; then
# echo "Error: '$filepath' is not a valid directory."
# return 1
# fi

# # Color variables
# local color_reset="\033[0m"
# # local color_main_dir="\033[1;34m"    # Blue for main directories
# local color_main_dir="\033[1;33m"    # Blue for main directories
# local color_sub_dir="\033[1;33m"     # Orange for subdirectories
# # local color_file="\033[0;32m"        # Green for files

# # Tree symbols
# local main_symbol="→"   # For main directories
# local sub_symbol=" ↳"   # For subdirectories It shows an a line and arrow right - https://www.compart.com/en/unicode/U+21B3

# # Prepare the find command
# local find_cmd=(find "$full_path" -mindepth 1 -maxdepth "$maxdepth")

# # Modify find command based on showhidden flag
# if [ "$showhidden" != "true" ]; then
# find_cmd+=(-not -path '*/.*')
# fi

# # Use process substitution to handle find results
# while IFS= read -r line; do
# # Strip the full path
# local relative_path="${line#$full_path/}"
# local depth=$(echo "$relative_path" | tr -cd '/' | wc -c)

# if [ $depth -eq 0 ]; then
# # Main directory level
# if [ -d "$line" ]; then
# echo -e "${color_main_dir}${main_symbol} ${relative_path}${color_reset}"
# else
# echo -e "${color_file}${main_symbol} ${relative_path}${color_reset}"
# fi
# else
# # Subdirectory level
# local prefix=$(printf "  %.0s" $(seq 1 $depth)) # Indentation
# if [ -d "$line" ]; then
# echo -e "${prefix}${color_sub_dir}${sub_symbol} ${relative_path##*/}${color_reset}"
# else
# echo -e "${prefix}${color_file}${sub_symbol} ${relative_path##*/}${color_reset}"
# fi
# fi
# done < <("${find_cmd[@]}")
# }
