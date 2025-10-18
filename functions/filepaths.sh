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
