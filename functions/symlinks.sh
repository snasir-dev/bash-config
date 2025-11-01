#!/bin/bash

# ======= SYMLINKS - FUNCTIONS =======

# SOURCE DEPENDENCIES
# 1. Source the file containing your helper functions
#    Make sure the path is correct relative to this script's location.
source "$BASH_DIR/functions/filepaths.sh" # Used in create_symlink to get absolute path.

# Clean short command to create symlink
# NOTE DEVELOPER MODE MUST BE ENABLED IN WINDOWS FOR NON-ADMIN USERS TO CREATE SYMLINKS
create_symlink() {
    local original_path="$1"
    local link_path="$2"
    # -s for symbolic links.
    # -f to force overwrite if link already exists. No longer will give 'file exists' error.
    # -n to treat link name as a normal file if it is ALREADY a symlink to a directory. Note that this does NOT prevent placing link INSIDE an existing directory. It only prevents treating the link itself as a directory when it is already a symlink to a directory.
    # -i to prompt before overwriting an existing file.
    # -v (verbose output) - print name of each linked file.
    ln -s -f -i -v "$original_path" "$link_path"
}

# -----------------------------------------------------------------------------
# Function: create_symlink_interactively_with_fzf
# Description: Interactively creates a native Windows symbolic link.
# Usage: Type `create_symlink_interactively_with_fzf` in the terminal and follow the prompts.
# -----------------------------------------------------------------------------
create_symlink_interactively_with_fzf() {
    # --- Function Start & Description ---

    # Store the directory where this script was launched from
    LAUNCH_DIR="$(pwd)"

    echo -e "\n\e[1;33m--- Executing Function (create_symlink) ---\e[0m"

    echo -e "\nThis script will create a native Windows symbolic link (a pointer)."

    echo -e "\nInput order:"
    echo "  1️⃣  ORIGINAL file/FOLDER → the target the link will point to."
    echo "  2️⃣  LINK LOCATION → where the link itself will be created."
    echo "      ⚠️  FILES will be OVERRIDDEN if they exists, DIRECTORIES if they EXIST, LINK we placed INSIDE of that DIRECTORY."

    echo "" # Blank line before input prompt

    # --- Read TARGET Path ---
    echo -e "LAUNCH DIRECTORY: \e[1;33m$LAUNCH_DIR\e[0m"

    echo -e "Enter the ORIGINAL path (To EXIT, press \e[1;31mq\e[0m or \e[1;31mQ\e[0m):"
    echo "  • The original file/folder where the data resides"
    echo "  • Can use RELATIVE PATHS (from FZF) or ABSOLUTE PATHS (/c/Users/...)"
    echo -e "  • Use \e[1;32mTAB\e[0m for path completion."
    echo -e "  • Use \e[1;32mCTRL+T\e[0m to launch FZF for searching. (FZF only shows dirs/files from your CURRENT directory). Relaunch function after navigating to correct directory if needed."

    # shellcheck disable=SC2162
    # read without -r will mangle backslashes. But here we WANT that behavior for path input. If we do -r, then any path with SPACES will treat is as a LITERAL backslash.
    # File name 'Test Document 1.txt' -> with -r: 'Test\ Document\ 1.txt' (NOT DESIRED), as readlink -f or other commands WILL NOT UNDERSTAND.
    # Without the '-e' flag, CTRL+T from fzf will not work allowing us to select paths.
    read -e -p "ORIGINAL PATH:> " original_path

    # Check if the user wants to quit.
    if [[ "$original_path" == "q" || "$original_path" == "Q" ]]; then
        echo -e "\n\e[1;33mFunction cancelled by user.\e[0m"
        echo -e "\e[1;33m--- Function Finished ---\e[0m\n"
        return
    fi

    # `readlink -f` gets the full canonical path.
    # Ex: $original_path = "original.txt" -> $original_path_abs = "/c/Users/Syed/docs/original.txt"
    # original_path_abs=$(readlink -f "$original_path")
    original_path_abs=$(get_absolute_path_unix "$original_path")

    # echo -e "\n\e[1;33m(DEBUGGING) ORIGINAL PATH (ABSOLUTE):\e[0m '$original_path_abs'\n"

    # --- VALIDATE TARGET PATH ---
    # Check if the provided target path actually exists before proceeding.
    if [ ! -e "$original_path_abs" ]; then
        echo -e "\n\e[1;31m❌ ERROR: The specified ORIGINAL path does not exist.\e[0m"
        echo "   Invalid Path: '$original_path_abs'"
        echo "Please provide a valid path to an existing file or directory."
        echo -e "\e[1;33m--- Function Finished ---\e[0m\n"
        return
    fi

    # --- Read LINK Path ---
    echo -e "Enter the LINK path (where the symlink will be created - To EXIT, press \e[1;31mq\e[0m or \e[1;31mQ\e[0m):"
    echo "  • If FILE already exists, you will be PROMPTED to OVERWRITE it (DELETING the existing file)"
    echo -e "  • If DIRECTORY already exists, it will place link INSIDE DIRECTORY. \e[1;31mIT WILL NEVER OVERRIDE DIRECTORIES\e[0m"

    # shellcheck disable=SC2162
    # read without -r will mangle backslashes. But here we WANT that behavior for path input. If we do -r, then any path with SPACES will treat is as a LITERAL backslash.
    # File name 'Test Document 1.txt' -> with -r: 'Test\ Document\ 1.txt' (NOT DESIRED), as readlink -f or other commands WILL NOT UNDERSTAND.
    # Without the '-e' flag, CTRL+T from fzf will not work allowing us to select paths.
    read -e -p "LINK PATH:> " link_path

    # Check if the user wants to quit.
    if [[ "$link_path" == "q" || "$link_path" == "Q" ]]; then
        echo -e "\n\e[1;33mFunction cancelled by user.\e[0m"
        echo -e "\e[1;33m--- Function Finished ---\e[0m\n"
        return
    fi

    # --- Resolve Relative Paths provided by user (when using FZF) to Absolute Paths ---
    # `readlink -f` gets the full canonical path.
    # Ex: $original_path = "original.txt" -> $original_path_abs = "/c/Users/Syed/docs/original.txt"
    # original_path_abs=$(readlink -f "$original_path")

    # For the link, we resolve the directory part and append the name.
    # Ex: $link_path = "~/links/new_link.txt"
    link_dir=$(dirname "$link_path")   # -> "~/links"
    link_name=$(basename "$link_path") # -> "new_link.txt"
    # link_path_abs="$(readlink -f "$link_dir")/$link_name"
    link_path_abs="$(get_absolute_path_unix "$link_dir")/$link_name" # -> "/c/Users/Syed/links/new_link.txt"

    # --- Create the Symlink ---
    echo -e "\nAttempting to create link..."
    # -s for symbolic links.
    # -f to force overwrite if link already exists. No longer will give 'file exists' error.
    # -n to treat link name as a normal file if it is ALREADY a symlink to a directory. Note that this does NOT prevent placing link INSIDE an existing directory. It only prevents treating the link itself as a directory when it is already a symlink to a directory.
    # -i to prompt before overwriting an existing file.
    # -v (verbose output) - print name of each linked file.
    ln -s -f -i -v "$original_path_abs" "$link_path_abs"

    # --- Provide Feedback ---
    if [ $? -eq 0 ]; then
        # Success
        # Convert paths to Windows format so it is easy to copy and paste in File Explorer.
        link_path_windows=$(cygpath -w "$link_path_abs")
        original_path_windows=$(cygpath -w "$original_path_abs")

        echo -e "\n\e[1;32m✅ SUCCESS:\e[0m Symbolic link created successfully."
        # Use printf to avoid backslash interpretation issues with echo -e. Avoids random tab issues etc.
        printf "   Link:      \e[1;33m'%s'\e[0m\n" "$link_path_windows"
        printf "   Points to (ORIGINAL FILE/FOLDER. Anytime you click link will take you to this place): \e[1;33m'%s'\e[0m\n" "$original_path_windows"
    else
        # Error
        echo -e "\n\e[1;31m❌ ERROR:\e[0m Failed to create symbolic link."
        echo "Please check the following common issues:"
        echo "1. Permissions: Is Developer Mode enabled? (Required for non-admin)."
        echo "2. Path Correctness: Are both paths valid?"
    fi
    echo "" # Blank line
    echo -e "\e[1;33m--- Function Finished ---\e[0m\n"
}
