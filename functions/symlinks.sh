#!/bin/bash

# ======= SYMLINKS - FUNCTIONS =======

# create_symlink() {
#     local target="$1"
#     local link_path="$2"
#     ln -s "$target" "$link_path"
# }

# -----------------------------------------------------------------------------
# Function: create_symlink
# Description: Interactively creates a native Windows symbolic link.
# Usage: Type `create_symlink` in the terminal and follow the prompts.
# -----------------------------------------------------------------------------
create_symlink() {
    # --- Function Start & Description ---

    # Store the directory where this script was launched from
    LAUNCH_DIR="$(pwd)"

    echo -e "\n\e[1;33m--- Executing Function (create_symlink) ---\e[0m"

    echo -e "\nThis script will create a native Windows symbolic link (a pointer)."
    echo "You can use either:"
    echo "  • RELATIVE PATHS (from FZF)"
    echo "  • ABSOLUTE PATHS (/c/Users/...)"
    echo "Both will work."

    echo -e "\nInput order:"
    echo "  1️⃣  ORIGINAL file/FOLDER → the target the link will point to."
    echo "  2️⃣  LINK LOCATION → where the link itself will be created."
    echo "      ⚠️ This file/FOLDER will be OVERRIDDEN IF it ALREADY EXISTS."

    echo -e "\nTips:"
    echo -e "  • Use \e[1;32mTAB\e[0m for path completion."
    echo -e "  • Use \e[1;32mCTRL+T\e[0m to launch FZF for searching."
    echo -e "    (FZF only shows dirs/files from your CURRENT directory:"
    echo -e "     \e[1;31m$LAUNCH_DIR\e[0m)"
    echo "    If that’s not the directory you want, press [Q or q] to exit,"
    echo "    then navigate to your desired directory and rerun this function."

    echo -e "\nTo EXIT anytime, press \e[1;31mq\e[0m or \e[1;31mQ\e[0m."

    echo "" # Blank line before input prompt

    # --- Read TARGET Path ---
    echo -e "LAUNCH DIRECTORY: \e[1;33m$LAUNCH_DIR\e[0m"

    # shellcheck disable=SC2162
    # read without -r will mangle backslashes. But here we WANT that behavior for path input. If we do -r, then any path with SPACES will treat is as a LITERAL backslash.
    # File name 'Test Document 1.txt' -> with -r: 'Test\ Document\ 1.txt' (NOT DESIRED), as readlink -f or other commands WILL NOT UNDERSTAND.
    read -e -p "Enter the ORIGINAL path (the original file/folder where the data resides): " original_path

    # Check if the user wants to quit.
    if [[ "$original_path" == "q" || "$original_path" == "Q" ]]; then
        echo -e "\n\e[1;33mFunction cancelled by user.\e[0m"
        echo -e "\e[1;33m--- Function Finished ---\e[0m\n"
        return
    fi

    # `readlink -f` gets the full canonical path.
    # Ex: $original_path = "original.txt" -> $original_path_abs = "/c/Users/Syed/docs/original.txt"
    original_path_abs=$(readlink -f "$original_path")

    echo -e "\n\e[1;33mORIGINAL PATH (ABSOLUTE):\e[0m '$original_path_abs'\n"

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
    # shellcheck disable=SC2162
    # read without -r will mangle backslashes. But here we WANT that behavior for path input. If we do -r, then any path with SPACES will treat is as a LITERAL backslash.
    # File name 'Test Document 1.txt' -> with -r: 'Test\ Document\ 1.txt' (NOT DESIRED), as readlink -f or other commands WILL NOT UNDERSTAND.
    read -e -p "Enter the LINK path (where the symlink will be created. File/Folder will be OVERRIDDEN IF it ALREADY EXISTS): " link_path

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
    link_dir=$(dirname "$link_path")                      # -> "~/links"
    link_name=$(basename "$link_path")                    # -> "new_link.txt"
    link_path_abs="$(readlink -f "$link_dir")/$link_name" # -> "/c/Users/Syed/links/new_link.txt"

    # --- Create the Symlink ---
    echo -e "\nAttempting to create link..."
    # -s for symbolic links.
    # -f to force overwrite if link already exists. No longer will give 'file exists' error.
    # -n to treat link name as a normal file if it is a symlink to a directory. Makes it so when link is to a directory, it will NEVER try to create symlink INSIDE that directory.
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
