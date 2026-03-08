#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/colors.sh
source "$SCRIPT_DIR/lib/colors.sh"
# shellcheck source=lib/check-deps.sh
source "$SCRIPT_DIR/lib/check-deps.sh"

# --- HELP ---
show_help() {
    cat << HELPEOF
${PURPLE}Usage:${NC} neckbeard nb-worktrees [-h]

Manage Git worktrees interactively. (Work in progress)

${YELLOW}Options:${NC}
  -h, --help    Show this help message and exit.

${YELLOW}Dependencies:${NC} git, fzf
HELPEOF
}

case "$1" in
    -h|--help) show_help; exit 0 ;;
esac

# --- DEPENDENCY CHECK ---
check_deps git fzf

# TODO: implement worktree management logic
echo -e "${YELLOW}nb-worktrees: not yet implemented.${NC}"
