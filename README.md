# Bash Dotfiles Configuration

A modular and portable Bash setup for Windows Git Bash.

This repository contains all my dotfiles, scripts, functions, aliases, completions, and plugin configurations used across command-line tools like `fzf`, `fd`, `bat`, `jq`, `docker`, `.NET`, and more. It’s designed for easy setup, automatic backup, and seamless customization of my shell environment.

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/snasir-dev/bash-dotfiles-config ~/.config/bash
   ```

2. Run the installation script:

   ```bash
   cd ~/.config/bash
   chmod +x ~/.config/bash/setup_bash.sh  # chmod +x adds execute permissions to the setup_bash.sh file.
   ./setup_bash.sh
   ```

3. Source the new configuration:

   ```bash
   source ~/.bashrc     # Load the new configuration
   # alternatively - we can also use any of following aliases we setup: 'src', 'reload', 'refresh', 'r', or 'R'
   src                  # Quick example of sourcing with the 'src' alias
   ```

## Local Customization

Create or modify `~/.bash_local` file for machine-specific settings:

<!-- - `~/.bash/env/variables_local`
- `~/.bash/aliases/aliases_local` -->

These files are ignored by Git and won't be overwritten during updates.

## Updating

To update configuration:

```bash
cd ~/.config/bash
git pull
source ~/.bashrc
```
