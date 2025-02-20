# Bash Configuration

Personal bash configuration files and scripts.

## Directory Structure

```
📁 ~/.bash/
├── 📁 @shell/              # Shell initialization files
│    ├── main
│    ├── bashrc
│    └── bash_profile
├── 📁 completions/         # Completion scripts
├── 📁 functions/           # Custom function definitions
├── 📁 aliases/             # Command aliases
├── 📁 scripts/             # Standalone shell scripts
├── 📁 env/                 # Environment variables
└── setup-bash-config.sh    # Setup/Installation Script         

```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/snasir95/bash-configuration ~/.bash
```

2. Run the installation script:
```bash
cd ~/.bash
chmod +x ~/.bash/setup-bash-config.sh  # chmod +x adds execute permissions to the setup-bash-config.sh file.
./setup-bash-config.sh
```

3. Source the new configuration:
```bash
source ~/.bashrc
```

## Local Customization

Create or modify `~/.bash_local` file for machine-specific settings:
<!-- - `~/.bash/env/variables_local`
- `~/.bash/aliases/aliases_local` -->

These files are ignored by Git and won't be overwritten during updates.

## Updating

To update your configuration:

```bash
cd ~/.bash
git pull
source ~/.bashrc
```