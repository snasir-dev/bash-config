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

#*************************************
# COMMIT MESSAGE FORMAT REMINDER
#*************************************

# MAIN COMMIT MESSAGE FORMAT REMINDER W/ EXAMPLES
commit_msg() {
    echo "📝 Commit Message Reminder 📝"
    echo "--- Commit Structure Template: ---"
    echo "  type(scope): subject    Example: feature(auth): add social login"
    echo "  │     │      └─> Concise description (50 chars max), lowercase, no period"
    echo "  │     └─> Optional area of change: users, auth, api, etc."
    echo "  └─> Required: feature|fix|docs|refactor|test|chore"
    # With separators "|" and Bold Header Row
    {
        echo "TYPE|DESCRIPTION|EXAMPLE"
        echo "feature|(New feature - Adds new functionality)|Example: feature(users): User registration"
        echo "fix|(Bug fix - Corrects an issue)|Example: fix(auth): Password reset bug"
        echo "docs|(Documentation - Documentation changes only)|Example: docs(api): Update endpoint docs"
        echo "style|(Formatting - No code change, just style)|Example: style(code): Consistent formatting"
        echo "refactor|(Code refactor - Code change, no new feature/bug fix)|Example: refactor(payment): Improve logic"
        echo "chore|(Maintenance - General maintenance tasks)|Example: chore(gitignore): Update ignore files"
        echo "test|(Testing - Tests related changes)|Example: test(auth): Unit tests for login"
        echo "performance|(Performance - Improves performance)|Example: performance(db): Optimize query latency"
        echo "build|(Build system - Build process or dependencies)|Example: build(deps): Update dependencies"
        echo "ci/cd|(CI/CD - CI configuration changes)|Example: ci(github): Setup CI workflow"
        echo "revert|(Revert commit - Undoes a previous commit)|Example: revert: Revert 'feature(users): ...'"
    } | column -t -s "|" -o " | " | sed '1s/.*/'$'\e[1m&\e[0m''/'
}
commit_msg_other() {
    other_commit_msg1
    other_commit_msg2
    other_commit_msg3

    # Option 1: Basic column formatting with headers
    {
        echo "TYPE|DESCRIPTION|EXAMPLE"
        echo "feat|(New feature)|feat(users): Add registration"
        echo "fix|(Bug fix)|fix(auth): Fix password reset"
        echo "docs|(Documentation)|docs(api): Update endpoint docs"
        echo "refactor|(Code refactor)|refactor(payment): Simplify logic"
        echo "chore|(Maintenance)|chore(deps): Update dependencies"
        echo "test|(Testing)|test(auth): Add login tests"
    } | column -t -s "|" -o "  |  "

    echo -e "\n------------------------"

    # Option 2: With separator ":" and Bold Header Row
    # {
    #     echo "TYPE:DESCRIPTION:EXAMPLE"
    #     echo "feat:(New feature):feat(users) - Add registration"
    #     echo "fix:(Bug fix):fix(auth) - Fix password reset"
    #     echo "docs:(Documentation):docs(api) - Update endpoint docs"
    # } | column -t -s ":" -o " | " | sed '1s/.*/'$'\e[1m&\e[0m''/'

    # With separators "|" and Bold Header Row
    {
        echo "TYPE|DESCRIPTION|EXAMPLE"
        echo "feat|(New feature)|feat(users):- Add registration"
        echo "fix|(Bug fix)|fix(auth):- Fix password reset"
        echo "docs|(Documentation)|docs(api):- Update endpoint docs"
    } | column -t -s "|" -o " | " | sed '1s/.*/'$'\e[1m&\e[0m''/'

    # {
    #     echo "TYPE:DESCRIPTION:EXAMPLE"
    #     echo "feature:(New feature - Adds new functionality):feature(users) - User registration"
    #     echo "fix:(Bug fix - Corrects an issue):fix(auth) - Password reset bug"
    #     echo "docs:(Documentation - Documentation changes only):docs(api) - Update endpoint docs"
    #     echo "style:(Formatting - No code change, just style):style(code) - Consistent formatting"
    #     echo "refactor:(Code refactor - Code change, no new feature/bug fix) - refactor(payment): Improve logic"
    #     echo "chore:(Maintenance - General maintenance tasks):chore(gitignore) - Update ignore files"
    #     echo "test:(Testing - Tests related changes):test(auth): - Unit tests for login"
    #     echo "performance:(Performance - Improves performance):performance(db): Optimize query latency"
    #     echo "build:(Build system - Build process or dependencies):build(deps): Update dependencies"
    #     echo "ci/cd:(CI/CD - CI configuration changes):ci(github): Setup CI workflow"
    #     echo "revert:(Revert commit - Undoes a previous commit):revert: Revert 'feature(users): ...'"
    # } | column -t -s ":" -o " | " | sed '1s/.*/'$'\e[1m&\e[0m''/'

    # {
    #     echo "TYPE:DESCRIPTION:EXAMPLE"
    #     echo "feature:(New feature - Adds new functionality):Example: feature(users): User registration"
    #     echo "fix:(Bug fix - Corrects an issue):Example: fix(auth): Password reset bug"
    #     echo "docs:(Documentation - Documentation changes only):Example: docs(api): Update endpoint docs"
    #     echo "style:(Formatting - No code change, just style):Example: style(code): Consistent formatting"
    #     echo "refactor:(Code refactor - Code change, no new feature/bug fix):Example: refactor(payment): Improve logic"
    #     echo "chore:(Maintenance - General maintenance tasks):Example: chore(gitignore): Update ignore files"
    #     echo "test:(Testing - Tests related changes):Example: test(auth): Unit tests for login"
    #     echo "performance:(Performance - Improves performance):Example: performance(db): Optimize query latency"
    #     echo "build:(Build system - Build process or dependencies):Example: build(deps): Update dependencies"
    #     echo "ci/cd:(CI/CD - CI configuration changes):Example: ci(github): Setup CI workflow"
    #     echo "revert:(Revert commit - Undoes a previous commit):Example: revert: Revert 'feature(users): ...'"
    # } | column -t -s ":" -o " | " | sed '1s/[^|]*/"  &  "/g' | sed '1s/.*/'$'\e[1m&\e[0m''/'

    # Option 3: Multi-table approach with different column counts
    # echo -e "\n--- Common Types ---"
    # {
    #     echo "PRIMARY|DESCRIPTION"
    #     echo "feat|(New feature)"
    #     echo "fix|(Bug fix)"
    #     echo "docs|(Documentation)"
    # } | column -t -s "|"

    # echo -e "\n--- Additional Types ---"
    # {
    #     echo "SECONDARY|DESCRIPTION"
    #     echo "style|(Formatting)"
    #     echo "perf|(Performance)"
    #     echo "build|(Build system)"
    # } | column -t -s "|"
}

other_commit_msg1() {
    echo "📝 Commit Message Reminder 📝"
    echo "--- Commit Structure Template: ---"
    echo "  type(scope): subject    Example: feature(auth): add social login"
    echo "  │     │      └─> Concise description (50 chars max), lowercase, no period"
    echo "  │     └─> Optional area of change: users, auth, api, etc."
    echo "  └─> Required: feature|fix|docs|refactor|test|chore"
    echo "--- Types: ---"
    echo "feature         : (New feature)          - Adds new functionality                   | Example: feature(users): User registration"
    echo "fix             : (Bug fix)              - Corrects an issue                        | Example: fix(auth): Password reset bug"
    echo "docs            : (Documentation)        - Documentation changes only               | Example: docs(api): Update endpoint docs"
    echo "style           : (Formatting)           - No code change, just style               | Example: style(code): Consistent formatting"
    echo "refactor        : (Code refactor)        - Code change, no new feature/bug fix      | Example: refactor(payment): Improve logic"
    echo "chore           : (Maintenance)          - General maintenance tasks                | Example: chore(gitignore): Update ignore files"
    echo "test            : (Testing)              - Tests related changes                    | Example: test(auth): Unit tests for login"
    echo "performance     : (Performance)          - Improves performance                     | Example: performance(db): Optimize query latency"
    echo "build           : (Build system)         - Build process or dependencies            | Example: build(deps): Update dependencies"
    echo "ci/cd           : (CI/CD)                - CI configuration changes                 | Example: ci(github): Setup CI workflow"
    echo "revert          : (Revert commit)        - Undoes a previous commit                 | Example: revert: Revert 'feature(users): ...'"

    echo -e "\n------------------------"
}

other_commit_msg2() {
    echo "📝 Commit Message Reminder 📝"
    {
        echo "TYPE:DESCRIPTION:EXAMPLE"
        echo "feat:(New feature):feat(users): Add registration"
        echo "fix:(Bug fix):fix(auth): Fix password reset"
        echo "docs:(Documentation):docs(api): Update endpoint docs"
        echo "refactor:(Code refactor):refactor(payment): Simplify logic"
        echo "chore:(Maintenance):chore(deps): Update dependencies"
        echo "test:(Testing):test(auth): Add login tests"
        echo "style:(Formatting):style(code): Format according to standards"
        echo "perf:(Performance):perf(db): Optimize query"
        echo "build:(Build system):build(deps): Update webpack"
        echo "ci:(CI config):ci(github): Setup workflow"
        echo "revert:(Revert commit):revert: Revert 'feat(users): ...'"
    } | column -t -s ":"

    echo -e "\n--- Format: type(scope): subject ---"
    echo "  • Scope is optional and indicates area of change"
    echo "  • Subject should be under 50 chars, lowercase, no period"

    echo -e "\n------------------------"
}

other_commit_msg3() {
    echo "📝 Commit Message Reminder 📝"
    printf "%-10s %-20s %-30s\n" "TYPE" "DESCRIPTION" "EXAMPLE"
    printf "%-10s %-20s %-30s\n" "feat" "(New feature)" "feat(users): Add registration"
    printf "%-10s %-20s %-30s\n" "fix" "(Bug fix)" "fix(auth): Fix password reset"
    # And so on for other types...

    echo -e "\n--- Format: type(scope): subject ---"

    echo -e "\n------------------------"
}

#*************************************
#
#*************************************
