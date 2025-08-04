#!/bin/bash

# Setup script for bash configuration repository
# - Copies .bashrc and .bash_profile from 'config/setup' into the user's home directory (~).
# - Backs up any existing versions to a timestamped backup folder
# - Creates a .bash_local override file if missing

# Define the base directory
BASH_DIR="$HOME/.bash"
BACKUP_DIR="$HOME/.bash/.bash_backup_$(date +%Y%m%d_%H%M%S)"
echo "BASH_DIR: $BASH_DIR"
echo "BACKUP_DIR: $BACKUP_DIR"

# Function to backup existing files
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
        echo "Backed up $file to $BACKUP_DIR/"
    fi
}

# Create necessary directories. They should already be created by the git clone command, this is just for redundancy.
# Should not be necessary. Cloning Repo should take care of this step.
# echo "Creating directory structure..."
# mkdir -p "$BASH_DIR"/{setup,completions/packages,functions,aliases,scripts,env,themes,plugins}

# Backup existing files
echo "Backing up existing .bashrc and .bash_profile files..."
backup_file "$HOME/.bashrc"
backup_file "$HOME/.bash_profile"

# Create symbolic links
echo "Creating symbolic links..."
ln -sf "$BASH_DIR/config/setup/.bashrc" "$HOME/.bashrc"
ln -sf "$BASH_DIR/config/setup/.bash_profile" "$HOME/.bash_profile"

# Create local override files if they don't exist
echo "Creating local override files. Source local machine-specific settings. Note '.bash_local' shouldn't be in version control..."
touch "$HOME/.bash_local"

echo "Installation complete!"
echo "Remember to source our bash config. Run Command: source ~/.bashrc"
