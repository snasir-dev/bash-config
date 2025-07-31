#!/bin/bash

# ======================================================================
# WINDOWS .EXE PROGRAMS TO ADD TO PATH - ADD PROGRAMS TO PATH
# ======================================================================

# The PATH variable is a special variable that tells your shell where to find executable programs
# IMPORTANT - You specify the DIRECTORY where the .exe is, do not need to specify the actual .exe file inside.
# Adding a directory to PATH makes the programs inside that directory runnable by name
# !!! VERY IMPORTANT - WE USE $PATH TO APPEND DIRECTORIES TO IT. MANY PROGRAMS ARE ADDED. ALTERING ENTIRE VALUE WILL BE CATASTROPHIC !!!

# EXAMPLE OF ADDING COMMANDS TO PATH
# export PATH="$PATH:/path/to/your/command"
# Example: export PATH="$PATH:/c/Program Files/Git/bin"

# ========= MY EXAMPLE =============
# My Example:
# Add the oh-my-posh executable to our $PATH in bash so it properly recognizes the 'oh-my-posh' command. To verify oh-my-posh command is working run command 'oh-my-posh version'
# export PATH="$PATH:/c/Users/Syed/AppData/Local/Programs/oh-my-posh/bin"
# ===================================

# ------ QuickLook - Windows File Preview Tool --------
# $FILE_PATH_TO_EXE

# Append directory to path
# $LOCALAPPDATA = C:\Users\Syed\AppData\Local
# Quicklook is installed in C:\Users\Syed\AppData\Local\Programs\QuickLook
QUICKLOOK_UNIX_PATH=$(cygpath -u "$LOCALAPPDATA/Programs/QuickLook")
export PATH="$QUICKLOOK_UNIX_PATH:$PATH"

# # Can also easily do $LOCALAPPDATA/Programs/QuickLook:$PATH
# # The shell is smart enough to correctly interpret the "mixed-style" path that results. It understands that $LOCALAPPDATA contains a Windows path (C:\Users\Syed\AppData\Local) and can correctly combine it with the Unix-style forward slash (/) you use for the rest of the path
# # It would just put the windows path when you would do echo $PATH. Would look like "C:\Users\Syed\AppData\Local/Programs/QuickLook"
# export PATH="$LOCALAPPDATA/Programs/QuickLook:$PATH"
