#!/bin/bash
# readlink -f {} | cygpath -m -f - | clip  -> Used in fzf.sh to copy Windows path of selected file to clipboard in the FZF_DEFAULT_OPTS variable.

# Below from symlinks.sh -> See section: Resolve Relative Paths provided by user (when using FZF) to Absolute Paths
#  # `readlink -f` gets the full canonical path.
#     # Ex: $original_path = "original.txt" -> $original_path_abs = "/c/Users/Syed/docs/original.txt"
#     original_path_abs=$(readlink -f "$original_path")

#     # For the link, we resolve the directory part and append the name.
#     # Ex: $link_path = "~/links/new_link.txt"
#     link_dir=$(dirname "$link_path")                      # -> "~/links"
#     link_name=$(basename "$link_path")                    # -> "new_link.txt"
#     link_path_abs="$(readlink -f "$link_dir")/$link_name" # -> "/c/Users/Syed/links/new_link.txt"

#====================================
# Get ABSOLUTE PATH from the specified directory
# Usable in File Explorer (e.g., C:\Users\...)
get_absolute_path_windows() {
    local dir_path="${1:-.}" # First Parameter. This is the path to provide. If no path provided, will use current directory ('.')
    # Convert the provided Unix-style path to an absolute Windows-style path with backslashes
    # 	-m, --mixed           like --windows, but with regular slashes (C:/WINNT)
    #   -u, --unix            (default) print Unix form of NAMEs (/cygdrive/c/winnt)
    #   -w, --windows         print Windows form of NAMEs (C:\WINNT)
    # cygpath -w "$(readlink -f "$1")"
    cygpath -a -w "$dir_path"
}

get_absolute_path_windows_forwardslashes() {
    #   -a, --absolute        output absolute path
    # 	-m, --mixed           like --windows, but with regular slashes (C:/WINNT)
    cygpath -a -m "${1:-.}"
}

get_absolute_path_unix() {
    #   -a, --absolute        output absolute path
    #   -u, --unix            (default) print Unix form of NAMEs (/cygdrive/c/winnt)
    # cygpath -a -u "${1:-.}" # cygpath to get absolute unix path - cygpath only available on windows, readlink is available for all unix systems. Great for portability.

    # READLINK only resolves POSIX/UNIX paths. It does NOT have ability to convert to WINDOWS PATHS. This is placed here as reference. Same result as -> cygpath -a -u "${1:-.}"
    readlink -f "${1:-.}"
}
#====================================

#====================================
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
    pwd | cygpath -m --file - # '-m' gives FORWARD slashes; '--file -' reads piped input (from 'pwd') via stdin
}
