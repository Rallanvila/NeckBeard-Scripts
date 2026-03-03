#!/bin/bash

REPO_DIR="$HOME/.neckBeard"

if [ -d "$REPO_DIR" ]; then
    echo "Updating existing installation..."
    cd "$REPO_DIR" && git pull
else
    echo "Cloning neckBeard..."
    git clone https://github.com/YOUR_USERNAME/neckBeard.git "$REPO_DIR"
fi

# Make everything executable
chmod +x "$REPO_DIR/neckBeard"
chmod +x "$REPO_DIR/scripts/"*.sh

# Add to PATH if not already there
if [[ ":$PATH:" != *":$REPO_DIR:"* ]]; then
    echo "Adding neckBeard to your PATH..."
    # Detect shell
    SHELL_CONFIG="$HOME/.zshrc"
    [[ "$SHELL" == *"bash"* ]] && SHELL_CONFIG="$HOME/.bashrc"
    
    echo "export PATH=\"\$PATH:$REPO_DIR\"" >> "$SHELL_CONFIG"
    echo "Installed! Please restart your terminal or run: source $SHELL_CONFIG"
fi
