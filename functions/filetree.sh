#!/bin/bash

# ==============================================================================
# filetree: Renders a tree view of a directory with icons and connectors.
#
# This function displays a directory's contents in a visual tree format,
# sorting directories before files at each level.
# ==============================================================================
# USAGE:
#   filetree [max_depth] [show_hidden] [directory_path]
#
# PARAMETERS:
#   max_depth:      (Optional) The maximum depth to traverse.
#                   Default: 1
#   show_hidden:    (Optional) Set to "true" to show hidden files/directories.
#                   Default: "false"
#   directory_path: (Optional) The path to the directory to list.
#                   Default: Current directory (.)
#
# EXAMPLES:
#   1. Show the current directory up to 1 levels deep:
#      filetree
#
#   2. Show the current directory up to 2 levels deep, including hidden files:
#      filetree 2 true
#
#   3. Show the '~/Documents/@MAIN-WORKSPACE' directory up to 4 levels deep, without hidden files:
#      filetree 4 false ~/Documents/@MAIN-WORKSPACE

# REFERENCE EXAMPLE OF HOW IT PRINTS DIRECTORIES:
# 📁 Observability/
# ├── 📁 01_Logging/
# │   ├── 📁 Centralized_Logging/
# │   │   ├── 📁 ELK_Stack/
# │   │   ├── 📁 AWS_CloudWatch_Logs/
# │   │   └── 📁 Serilog/
# │   └── 📁 Structured_Logging/
# ├── 📁 02_Metrics/
# │   ├── 📁 Application_Metrics/
# │   │   ├── 📁 Prometheus/
# │   │   └── 📁 AWS_CloudWatch_Metrics/
# │   ├── 📁 Infrastructure_Metrics/
# │   └── 📁 Time_Series_Storage/
# │       └── 📁 InfluxDB/
# ├── 📁 03_Tracing/
# │   ├── 📁 Distributed_Tracing/
# │   │   ├── 📁 OpenTelemetry/
# │   │   └── 📁 AWS_X-Ray/
# │   └── 📁 APM_Tools/
# ├── 📁 04_Error_Monitoring/
# │   ├── 📁 Sentry/
# │   └── 📁 Application_Insights/
# ├── 📁 05_Visualization/
# │   ├── 📁 Grafana/
# │   ├── 📁 Kibana/
# │   └── 📁 CloudWatch_Dashboards/
# ├── 📁 06_Alerting/
# │   ├── 📁 Prometheus_AlertManager/
# │   ├── 📁 CloudWatch_Alarms/
# │   └── 📁 Grafana_Alerts/
# └── 📁 07_Standards_And_Configs/
#     ├── 📁 OpenTelemetry_Configs/
#     ├── 📁 Logging_Standards/
#     └── 📁 Metric_Conventions/
# ==============================================================================
filetree() {
    # --- 1. ARGUMENT HANDLING ---
    # Assign arguments to descriptive local variables with default values.
    # The ":-" operator uses the provided value if it exists, otherwise it falls back to the default.
    local max_depth="${1:-1}"
    local show_hidden="${2:-false}"
    local directory_path="${3:-.}"
    local absolute_path

    # Resolve the provided path to its full, absolute path.
    absolute_path=$(readlink -f "$directory_path")

    # --- 2. VALIDATION ---
    # Check if the resolved path is actually a directory. If not, print an error and exit.
    if [ ! -d "$absolute_path" ]; then
        echo "Error: '$directory_path' is not a valid directory."
        return 1
    fi

    # --- 3. CONFIGURATION ---
    # Define colors and icons for the output for easy customization.
    local color_reset="\033[0m"
    # local color_dir="\033[1;34m"  # Blue for directories
    local color_dir="\033[1;33m"  # Yellow color for directories
    local color_file="\033[0;37m" # White for files
    local dir_icon="📁"
    local file_icon="📄"

    # --- 4. CORE RECURSIVE FUNCTION ---
    # This internal function is responsible for rendering one level of the tree
    # and then calling itself for any subdirectories found.
    # @param1 path_to_scan: The directory whose contents should be listed.
    # @param2 prefix: The string of tree connectors ('│   ', '    ') to print before the entry.
    # @param3 depth: The current traversal depth.
    render_tree_level() {
        local path_to_scan="$1"
        local prefix="$2"
        local depth="$3"

        # Base case for the recursion: if we've reached the max depth, stop.
        if [ "$depth" -ge "$max_depth" ]; then
            return
        fi

        # --- Prepare `find` options ---
        # Start with options to only search one level deep.
        local find_options=(-mindepth 1 -maxdepth 1)
        # If show_hidden is false, add an option to ignore paths containing '/.'.
        if [ "$show_hidden" != "true" ]; then
            find_options+=(-not -path '*/.*')
        fi

        # --- Read entries into an array, sorted by type (dirs first), then name ---
        local entries=()
        # The `-printf "%y %p\n"` command tells find to output the file type ('d' or 'f')
        # followed by the path. We pipe this to `sort`, which naturally sorts 'd' before 'f'.
        while IFS= read -r line; do
            # Use Bash substring expansion to remove the first two characters ('d ' or 'f ')
            # from each line, leaving only the path.
            entries+=("${line:2}")
        done < <(find "$path_to_scan" "${find_options[@]}" -printf "%y %p\n" | sort)

        # Get the total number of entries to identify the last one.
        local total_entries=${#entries[@]}
        local count=0

        # --- Iterate over the sorted list of entries ---
        for entry in "${entries[@]}"; do
            ((count++))

            # --- Determine tree connectors ---
            local connector
            local child_prefix
            # If this is the last entry in the directory, use the "end" connector.
            if [ "$count" -eq "$total_entries" ]; then
                connector="└──" # This is the last item in the list.
                # The prefix for its children will not have a vertical line.
                child_prefix="${prefix}    "
            else
                connector="├──" # This is not the last item.
                # The prefix for its children needs a vertical line to show the branch continues.
                child_prefix="${prefix}│   "
            fi

            # Get just the name of the file or directory for printing.
            local entry_name
            entry_name=$(basename "$entry")

            # --- Print the entry and recurse if it's a directory ---
            if [ -d "$entry" ]; then
                echo -e "${prefix}${connector} ${color_dir}${dir_icon} ${entry_name}/${color_reset}"
                # RECURSIVE CALL: Render the contents of this subdirectory.
                render_tree_level "$entry" "$child_prefix" $((depth + 1))
            elif [ -f "$entry" ]; then
                echo -e "${prefix}${connector} ${color_file}${file_icon} ${entry_name}${color_reset}"
            fi
        done
    }

    # --- 5. INITIAL CALL ---
    # Start the process by printing the root directory of the tree.
    echo -e "${color_dir}${dir_icon} $(basename "$absolute_path")/${color_reset}"

    # Make the first call to the recursive function to render the contents.
    # The initial prefix is empty, and the initial depth is 0.
    render_tree_level "$absolute_path" "" 0
}

# Function to show directory structure in a tree-like format
# Will run filetree shell method below.
# Remember after ft can specify parameters: ft 1 . true

#alias ft="filetree" # Moved to aliases.sh

# OLD IMPLEMENTATION 3
# filetree() {
#     # Default values
#     local maxdepth="${1:-1}"      # Default depth is 1
#     local filepath="${2:-.}"      # Default to the current directory
#     local showhidden="${3:-true}" # Default to not showing hidden files
#     local full_path
#     full_path=$(readlink -f "$filepath")

#     # Validate the directory
#     if [ ! -d "$full_path" ]; then
#         echo "Error: '$filepath' is not a valid directory."
#         return 1
#     fi

#     # Color variables
#     local color_reset="\033[0m"
#     local color_dir="\033[1;33m"  # Yellow for directories
#     local color_file="\033[0;37m" # White for files

#     # Tree symbols
#     local main_symbol="→" # For main entries
#     # local sub_symbol="  ↳" # For subdirectories
#     local sub_symbol="  📁" # For subdirectories

#     # Recursive function to list directories and files
#     list_dir() {
#         local current_path="$1"
#         local current_depth="$2"

#         # Prevent listing beyond max depth
#         if [ "$current_depth" -ge "$maxdepth" ]; then
#             return
#         fi

#         # Prepare find options
#         local find_options=(-mindepth 1 -maxdepth 1)
#         if [ "$showhidden" != "true" ]; then
#             find_options+=(-not -path '*/.*')
#         fi

#         # Separate directories and files, filtering out empty/non-existent directories
#         local directories
#         local files

#         # Get non-empty directories first (sorted)
#         directories=$(find "$current_path" "${find_options[@]}" -type d | sort)

#         # Get files separately (sorted)
#         files=$(find "$current_path" "${find_options[@]}" -type f | sort)

#         # Iterate over directories first
#         while IFS= read -r entry; do
#             # Check if directory is still valid
#             if [ ! -d "$entry" ]; then
#                 continue
#             fi

#             local relative_path="${entry#$full_path/}"                # Remove base path
#             local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

#             if [ "$current_depth" -eq 0 ]; then
#                 echo -e "${color_dir}${main_symbol} ${relative_path}${color_reset}"
#             else
#                 echo -e "${prefix}${color_dir}${sub_symbol} ${relative_path##*/}${color_reset}"
#             fi

#             # Recursively list contents of this directory if depth allows
#             list_dir "$entry" $((current_depth + 1))
#         done <<<"$directories"

#         # Then iterate over files
#         while IFS= read -r entry; do
#             # Check if file is still valid
#             if [ ! -f "$entry" ]; then
#                 continue
#             fi

#             local relative_path="${entry#$full_path/}"                # Remove base path
#             local prefix=$(printf "  %.0s" $(seq 1 "$current_depth")) # Indentation

#             if [ "$current_depth" -eq 0 ]; then
#                 echo -e "${color_file}${main_symbol} ${relative_path}${color_reset}"
#             else
#                 echo -e "${prefix}${color_file}${sub_symbol} ${relative_path##*/}${color_reset}"
#             fi
#         done <<<"$files"
#     }

#     # Start the listing from the given path
#     list_dir "$full_path" 0
# }

# OLD IMPLEMENTATION 4
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
