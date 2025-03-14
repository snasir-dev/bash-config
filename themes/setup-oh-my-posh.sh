#!/bin/bash

# Oh My Posh allows you to use stunning themes in PowerShell, Git Bash, or WSL.
# We are setting Oh My Posh specifically for bash only.
# Windows Installation Instructions: https://ohmyposh.dev/docs/installation/windows
# IMPORTANT: Oh My Posh requires Nerd Fonts to be installed on your system. Oh My Posh dev recommends installing 'meslo' font. You can do it directly from oh-my-posh command line once oh-my-posh is installed.
# Once that is completed, it will show the default theme.
# You can export any theme by running command:
# "oh-my-posh config export --output ./<your-file-name>.json"

show_nerd_font_instructions() {
    # --- Nerd Font Information Message (Moved to the END of the function) ---
    echo -e "\n" # Add an empty line for visual separation
    echo "-------------------------------------------------------------------"
    echo "IMPORTANT: Oh My Posh requires a Nerd Font. Nerd Fonts are popular fonts that are patched to include icons."
    echo "To see the icons displayed in Oh My Posh, install a Nerd Font, and configure your terminal to use it"
    echo -e "\n"
    echo "It's highly recommended to install a Nerd Font, such as Meslo."
    echo "You can install Meslo Nerd Font by running:"
    echo "   oh-my-posh font install meslo"
    echo -e "\n"
    echo "Alternatively, see the official documentation for font installation:"
    echo "   https://ohmyposh.dev/docs/installation/fonts#installation"
    echo -e "\n"
    echo "After installation, set your terminal font to a Nerd Font in your"
    echo "terminal settings (e.g., in VS Code settings: Terminal > Integrated: Font Family). If you use Settings.json in VS Code, add the following line:"
    echo "   \"terminal.integrated.fontFamily\": \"MesloLGM Nerd Font\""
    echo "-------------------------------------------------------------------"
    echo "" # Add an empty line for visual separation
    # echo "Oh My Posh requires Nerd Fonts to be installed on your system."
    # echo "They recommend installing 'meslo' font. You can do it directory from oh-my-posh command line once oh-my-posh is installed."
}

# Function to install Oh My Posh
install_oh_my_posh() {
    # Check if Oh My Posh is already installed
    if command -v oh-my-posh &>/dev/null; then
        # echo "Oh My Posh is already installed. Skipping installation."
        return 0
    fi

    # Try installing with winget
    if command -v winget &>/dev/null; then
        echo "Installing Oh My Posh via winget..."

        winget install JanDeDobbeleer.OhMyPosh -s winget

        echo "Oh My Posh installed successfully! However, Be warned! Oh My Posh command might not be immediately available."
        echo "You may need to restart this terminal or source this shell configuration file."

        show_nerd_font_instructions # Show Nerd Font instructions

        return $?
    fi

    # Try installing with chocolatey
    if command -v choco &>/dev/null; then
        echo "Installing Oh My Posh via chocolatey..."
        choco install oh-my-posh
        echo "Oh My Posh installed successfully! However, Be warned! Oh My Posh command might not be immediately available."
        echo "You may need to restart this terminal or source this shell configuration file."

        show_nerd_font_instructions # Show Nerd Font instructions

        return $?
    fi

    # If neither winget nor chocolatey is available
    echo "Unable to install Oh My Posh. Please install winget or chocolatey."
    return 1
}

# Function to setup Oh My Posh in bash
setup_oh_my_posh() {
    #     # Path to save the theme
    #     THEME_PATH="$THEMES_DIR/custom.omp.json"

    #     # Create a default theme if it doesn't exist
    #     if [ ! -f "$THEME_PATH" ]; then
    #         cat > "$THEME_PATH" << EOL
    # {
    #     "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
    #     "blocks": [
    #         {
    #             "type": "prompt",
    #             "alignment": "left",
    #             "segments": [
    #                 {
    #                     "type": "path",
    #                     "style": "plain",
    #                     "foreground": "blue"
    #                 },
    #                 {
    #                     "type": "git",
    #                     "style": "plain",
    #                     "foreground": "green"
    #                 }
    #             ]
    #         }
    #     ]
    # }
    # EOL
    #     fi

    # --- Bash Shell Integration ---

    # Set Default Theme in Oh My Posh. Theme is specified when initializing the shell.
    # To view popular themes, go to: https://ohmyposh.dev/docs/themes#quick-term

    # TODO: Add logic to quick-term-main-theme.json file to dynamically show different "session" segment information depending on the session type (e.g., SSH, WSL, etc.). Add logic to show different information when using docker (docker context), Kubernetes (k8s context / namespace), or AWS CLI (AWS CLI profile)
    THEMES_DIR="$HOME/.bash/themes/config"
    THEME_NAME="quick-term-main-theme.json"
    THEME_LOCAL_PATH="$THEMES_DIR/$THEME_NAME" # local directory
    # THEME_REMOTE_PATH_URL="https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/lightgreen.omp.json" # remote github directory

    # You can export any theme by running command:
    # "oh-my-posh config export --output ./<your-file-name>.json" # current directory
    # oh-my-posh config export --output ~/.bash/themes/config/<name>.json

    # The 'command -v oh-my-posh &> /dev/null' checks if oh-my-posh command is installed
    if command -v oh-my-posh &>/dev/null; then
        # eval "$(oh-my-posh init bash)"
        eval "$(oh-my-posh init bash --config $THEME_LOCAL_PATH)"
        # eval "$(oh-my-posh init bash --config $THEME_REMOTE_PATH_URL)"

        # echo "Oh My Posh is using Remote URL. THEME_REMOTE_PATH_URL: $THEME_REMOTE_PATH_URL"

    fi
}

# Main installation process
main() {
    install_oh_my_posh # Install Oh My Posh
    setup_oh_my_posh   # Setup Oh My Posh in bash
}

# Run the main function
main
