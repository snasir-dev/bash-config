# Bash Configuration

Personal bash configuration files and scripts.

## Directory Structure

```
📁 ~/.bash/
├── 📁 aliases/
├── 📁 completions/
│   └── 📁 third-party/
├── 📁 env/
├── 📁 functions/
├── 📁 plugins/
├── 📁 scripts/
├── 📁 themes/
├── 📁 setup/
│   ├── 📄 bashrc              # Symlinked to ~/.bashrc (updated by setup_bash_config.sh)
│   └── 📄 bash_profile        # Symlinked to ~/.bash_profile (updated by setup_bash_config.sh)
├── 📄 main.sh                 # Entrypoint: main file to source
└── 📄 setup_bash_config.sh    # Setup/Installation Script
```

## Installation

1. Clone this repository:

```bash
git clone https://github.com/snasir-dev/bash-configuration ~/.bash
```

2. Run the installation script:

```bash
cd ~/.bash
chmod +x ~/.bash/setup_bash_config.sh  # chmod +x adds execute permissions to the setup_bash_config.sh file.
./setup_bash_config.sh
```

3. Source the new configuration:

```bash
source ~/.bashrc     # Load the new configuration
# alternatively - we can also use the following aliases we setup: 'src' or 'reload'
src                  # Quick reload alias
reload               # Alternative reload alias
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
