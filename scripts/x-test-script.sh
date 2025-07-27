#!/bin/bash

# This script is a test script to demonstrate functionality.

x-test-script() {
    echo "Running x-test.sh script..."

    # Example command to run
    echo "This is a test command."

    # You can add more commands here as needed
    echo "x-test.sh completed successfully."

    # POWERTOYS_PLUGIN_DEST_PATH="$LOCALAPPDATA/Microsoft/PowerToys/PowerToys Run/Plugins"
    # WINDOWS_PLUGIN_DEST_PATH=$(cygpath -w "$POWERTOYS_PLUGIN_DEST_PATH")
    WINDOWS_PLUGIN_DEST_PATH="$(cygpath -w "$LOCALAPPDATA/Microsoft/PowerToys/PowerToys Run/Plugins")"

    echo "📂 Opening PowerToys plugin directory in File Explorer..."
    echo "🔍 PowerToys Plugin Directory (Windows Path): $WINDOWS_PLUGIN_DEST_PATH"
    explorer "$WINDOWS_PLUGIN_DEST_PATH"

}

x-test-script "$@"

# DO NOT NEED TO USE FUNCTIONS CAN JUST PUT INFORMATION DIRECTLY. See 'x-powertoys-run-install-plugin.sh' for example.
