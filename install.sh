#!/bin/bash

REPO_DIR="$HOME/.neckBeard"
GITHUB_URL="https://github.com/Rallanvila/NeckBeard-Scripts.git"

# 1. Clone or Update
if [ -d "$REPO_DIR" ]; then
    echo "Updating existing installation..."
    cd "$REPO_DIR" && git pull
else
    echo "Cloning neckBeard..."
    git clone "$GITHUB_URL" "$REPO_DIR"
fi

# 2. Fix Permissions (Prevents 'permission denied')
chmod +x "$REPO_DIR/neckbeard"
chmod +x "$REPO_DIR/scripts/"*.sh

# 3. Path Configuration
if [[ ":$PATH:" != *":$REPO_DIR:"* ]]; then
    echo "Adding neckBeard to your PATH..."
    # Detect shell config
    SHELL_CONFIG="$HOME/.zshrc"
    [[ "$SHELL" == *"bash"* ]] && SHELL_CONFIG="$HOME/.bashrc"
    
    echo "export PATH=\"\$PATH:$REPO_DIR\"" >> "$SHELL_CONFIG"
    
    # Reload shell for this session
    export PATH="$PATH:$REPO_DIR"
    echo "✅ Path updated. Run 'source $SHELL_CONFIG' to finalize your current terminal."
fi

echo "🧔 Setup complete, you can now run neckbeard scripts!"
