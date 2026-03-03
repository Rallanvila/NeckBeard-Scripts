#!/bin/bash
REPO_DIR="$HOME/.neckBeard"

# 1. Clone or Update
if [ -d "$REPO_DIR" ]; then
    echo "Updating existing installation..."
    cd "$REPO_DIR" && git pull
else
    echo "Cloning neckBeard..."
    git clone https://github.com/Rallanvila/NeckBeard-Scripts.git "$REPO_DIR"
fi

# 2. Make everything executable
chmod +x "$REPO_DIR/neckbeard"
chmod +x "$REPO_DIR/scripts/"*.sh

# 3. Add to PATH if not already there
if [[ ":$PATH:" != *":$REPO_DIR:"* ]]; then
    echo "Adding neckBeard to your PATH..."
    
    # Detect shell config file
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    
    echo "export PATH=\"\$PATH:$REPO_DIR\"" >> "$SHELL_CONFIG"
    
    # Source it for the current session (though this only affects this subshell)
    # shellcheck source=/dev/null
    source "$SHELL_CONFIG"
    
    echo "✅ Installed! Run 'source $SHELL_CONFIG' or restart your terminal."
fi

echo "🚀 You can now run: neckbeard fzfDirectories"
