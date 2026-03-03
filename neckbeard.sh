#!/usr/bin/env bash

# Get the directory where this script actually lives
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME=$1

# Help menu if no argument is provided
if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: neckBeard <scriptName>"
    echo "Available scripts:"
    fd . "$INSTALL_DIR/scripts" -t f -e sh --exec echo '{/.}'
    # ls "$INSTALL_DIR/scripts" | sed 's/\.sh//'
    exit 1
fi

# Path to the actual script
TARGET_SCRIPT="$INSTALL_DIR/scripts/$SCRIPT_NAME.sh"

if [ -f "$TARGET_SCRIPT" ]; then
    shift # Remove 'scriptName' from arguments so the sub-script gets the rest
    bash "$TARGET_SCRIPT" "$@"
else
    echo "Error: Script '$SCRIPT_NAME' not found in $INSTALL_DIR/scripts"
    exit 1
fi
