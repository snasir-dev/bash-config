#!/bin/bash

# git fsck --full --unreachable → Lists unreachable objects.
# grep "commit" → Filters only commit objects.
# awk '{print $3}' → Extracts only the commit hashes.
# xargs git log --format="%h %cd %s" --date=format:'%Y-%m-%d %H:%M:%S' → Displays:
# %h → Short commit hash.
# %cd → Commit date.
# %s → Commit message.
# --date=format:'%Y-%m-%d %H:%M:%S' → Formats the date like YYYY-MM-DD HH:MM:SS.

# Example OUTPUT:
# abc1234 2024-03-10 14:30:45 Fix login issue
# def5678 2024-03-11 09:15:22 Refactored API

# To use command do: git_fsck
# Can specify num of rows. This will try to get 10 rows: git_fsck 10

git_fsck() {
    local num_rows="${1:-1}" # If num_rows is empty or 0, set it to 1
    # Check if num_rows is less than 1
    if [ "$num_rows" -lt 1 ]; then
        num_rows=1
    fi

    git fsck --full --unreachable | grep "commit" | awk '{print $3}' | xargs git log --format="%h %cd %s" --date=format:'%Y-%m-%d %H:%M:%S' | head -n "$num_rows"
}

# g2() {
#     git fsck --full --unreachable | while read line; do
#         if echo "$line" | grep -q "dangling"; then
#             # Color dangling objects red
#             echo -e "\033[31m$line\033[0m"
#         elif echo "$line" | grep -q "unreachable"; then
#             # Color unreachable objects yellow
#             echo -e "\033[33m$line\033[0m"
#         else
#             echo "$line"
#         fi
#     done | grep "commit" | awk '{print $3}' | xargs git log --format="%h %cd %s" --date=format:'%Y-%m-%d %H:%M:%S' | head -n "$num_rows"

# }
