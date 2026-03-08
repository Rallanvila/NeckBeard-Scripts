#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/colors.sh
source "$SCRIPT_DIR/lib/colors.sh"

REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- HELP ---
show_help() {
    cat << EOF
${PURPLE}Usage:${NC} neckbeard update [-h]

Pull the latest NeckBeard changes from GitHub, fix script permissions,
and reset the update-check cache.

${YELLOW}Options:${NC}
  -h, --help    Show this help message and exit.

${CYAN}Notes:${NC}
  Deletes .last_update_check so the next neckbeard run re-checks for updates.
  Requires an active internet connection and a tracked upstream branch.
EOF
}

case "$1" in
    -h|--help) show_help; exit 0 ;;
esac

# --- MAN PAGE HELPER ---
install_man_pages() {
    local man_dir="$HOME/.local/share/man/man1"
    mkdir -p "$man_dir"
    cp "$REPO_DIR/man/neckbeard.1" "$man_dir/neckbeard.1"
    echo -e "${GREEN}Man page installed → $man_dir/neckbeard.1${NC}"
}

echo -e "${BLUE}Checking for updates...${NC}"

git -C "$REPO_DIR" fetch origin 2>/dev/null || {
    echo -e "${RED}Could not reach remote. Check your connection.${NC}"
    exit 1
}

LOCAL=$(git -C "$REPO_DIR" rev-parse HEAD)
REMOTE=$(git -C "$REPO_DIR" rev-parse "@{u}" 2>/dev/null)

if [ -z "$REMOTE" ]; then
    echo -e "${YELLOW}No upstream branch tracked. Nothing to update.${NC}"
    exit 0
fi

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}Already up to date.${NC}"

    # Still check man page even when scripts are current
    if [ ! -f "$HOME/.local/share/man/man1/neckbeard.1" ]; then
        echo -e "${YELLOW}Man page not installed. Installing...${NC}"
        install_man_pages
    fi

    exit 0
fi

echo -e "${CYAN}Pulling latest changes...${NC}"
git -C "$REPO_DIR" pull || {
    echo -e "${RED}Update failed. Try manually: git -C $REPO_DIR pull${NC}"
    exit 1
}

# Fix permissions for all scripts including new ones
chmod +x "$REPO_DIR/neckbeard"
chmod +x "$REPO_DIR/scripts/"*.sh
chmod +x "$REPO_DIR/scripts/lib/"*.sh

# Install / refresh man page
install_man_pages

# Reset the update-check timestamp so the next run re-checks
rm -f "$REPO_DIR/.last_update_check"

echo -e "${GREEN}✅ NeckBeard updated successfully!${NC}"
