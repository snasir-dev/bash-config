#!/bin/bash

# setup-bash-config.sh - Setup script for bash configuration repository

# Define the base directory
BASH_DIR="$HOME/.bash"
BACKUP_DIR="$HOME/.bash_backup_$(date +%Y%m%d_%H%M%S)"
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

# Create necessary directories
echo "Creating directory structure..."
mkdir -p "$BASH_DIR"/{completions,functions,aliases,scripts,env,@shell}

# Backup existing files
echo "Backing up existing files..."
backup_file "$HOME/.bashrc"
backup_file "$HOME/.bash_profile"

# Create symbolic links
echo "Creating symbolic links..."
ln -sf "$BASH_DIR/@shell/bashrc" "$HOME/.bashrc"
ln -sf "$BASH_DIR/@shell/bash_profile" "$HOME/.bash_profile"

# Create local override files if they don't exist
echo "Creating local override files. Source local machine-specific settings These settings shouldn't be in version control..."
touch "$HOME/.bash_local"


echo "Installation complete!"
echo "Please source your new configuration: source ~/.bashrc"