#!/usr/bin/env bash

# Unset to prevent inherited values from the current shell session
unset DEV_DIR_PATH

# Define colors (using literal escape characters for Heredoc compatibility)
RED=$'\e[0;31m'
GREEN=$'\e[0;32m'
YELLOW=$'\e[1;33m'
BLUE=$'\e[0;34m'
PURPLE=$'\e[0;35m'
CYAN=$'\e[0;36m'
NC=$'\e[0m' 

# Define paths
CONFIG_DIR="$HOME/dev/neckBeardScripts"
CONFIG_FILE="$CONFIG_DIR/settings.env"
TMUX_CONFIG_DIR="$HOME/.config/tmuxinator"

# --- HELP FUNCTION ---
show_help() {
    cat << EOF
${PURPLE}Usage:${NC} ./fzfDirectories.sh [OPTIONS]

An interactive script to boot Tmuxinator projects by selecting directories.

${YELLOW}Options:${NC}
  -h, --help     Show this help message and exit.
  -r, --reset    Delete saved settings and reconfigure.

${CYAN}Workflow:${NC}
  1. Checks for saved dev directory in $CONFIG_FILE.
  2. Select a Tmuxinator config (*.yml) from $TMUX_CONFIG_DIR.
  3. Select a subdirectory to pass as the first argument.
  4. Launches Tmuxinator.
EOF
}

# --- ARGUMENT HANDLING ---
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -r|--reset)
        if [ -f "$CONFIG_FILE" ]; then
            rm "$CONFIG_FILE"
            echo -e "${GREEN}Settings file deleted.${NC}"
        else
            echo -e "${YELLOW}No settings file found to delete.${NC}"
        fi
        # We don't exit here so it immediately triggers the setup below
        ;;
esac

# --- SETUP / LOAD SETTINGS ---
# -s checks if file exists AND is not empty
if [ ! -s "$CONFIG_FILE" ]; then
    echo -e "${BLUE}First time setup: Let's configure your dev directory.${NC}"
    mkdir -p "$CONFIG_DIR"
    
    # Prompt for path
    echo -ne "${YELLOW}Enter your full dev directory path (e.g., ~/dev): ${NC}"
    read -r USER_PATH
    
    # Expand tilde
    USER_PATH="${USER_PATH/#\~/$HOME}"
    
    # Save absolute path
    echo "DEV_DIR_PATH=\"$USER_PATH\"" > "$CONFIG_FILE"
    echo -e "${GREEN}Settings saved to $CONFIG_FILE${NC}"
fi

source "$CONFIG_FILE"

# --- VALIDATE ENVIRONMENT ---
if [ ! -d "$DEV_DIR_PATH" ]; then
    echo -e "${RED}Error: $DEV_DIR_PATH does not exist.${NC} Check $CONFIG_FILE"
    exit 1
fi

if ! command -v tmuxinator &> /dev/null; then
    echo -e "${RED}Error: tmuxinator not found.${NC} Ensure Ruby gems are in your PATH"
    exit 1
fi

# --- SELECT TMUXINATOR PROJECT ---
while true; do
    # Enable nullglob so if no *.yaml files exist, the pattern disappears
    shopt -s nullglob
    # Use an array to safely capture the files
    FILES=("$TMUX_CONFIG_DIR"/*.{yml,yaml})
    shopt -u nullglob # Turn it off immediately after use

    if [ ${#FILES[@]} -eq 0 ]; then
        echo -e "${RED}Error: No projects found in $TMUX_CONFIG_DIR${NC}"
        exit 1
    fi

    # Pass only the filenames to fzf
    RAW_SELECTION=$(printf "%s\n" "${FILES[@]##*/}" | fzf --header="1. Select Tmuxinator Config")

    if [ -z "$RAW_SELECTION" ]; then
        echo -e "${YELLOW}Selection cancelled.${NC}"
        exit 0
    fi

    # Slice the extension for tmuxinator (e.g., 'project.yml' -> 'project')
    SELECTED_PROJECT="${RAW_SELECTION%.*}"

    if tmuxinator list | grep -q "\b$SELECTED_PROJECT\b"; then
        break
    else
        echo -e "${RED}Error: '$SELECTED_PROJECT' is invalid.${NC}"
        sleep 1
    fi
done

# --- SELECT SUB-DIRECTORY ---
cd "$DEV_DIR_PATH" || exit
echo -e "${CYAN}Searching directories in $DEV_DIR_PATH...${NC}"

SELECTED_DIR=$(fd . -t d -d 1 --exec echo '{/}' | fzf --header="2. Select Folder for <%= @args[0] %>")

if [ -z "$SELECTED_DIR" ]; then
    echo "No directory selected. Exiting."
    exit 0
fi

# --- START ---
echo -e "${PURPLE}Starting project '$SELECTED_PROJECT' with argument '$SELECTED_DIR'...${NC}"
tmuxinator start "$SELECTED_PROJECT" "$SELECTED_DIR"
