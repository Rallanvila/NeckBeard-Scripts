#!/usr/bin/env bash
# Dependency checker — source this file, do not execute it directly.
# Requires colors.sh to be sourced first.
#
# Usage:
#   check_deps <cmd1> <cmd2> ...
#
# Optional: define an associative array to map command names to package names
# before calling check_deps. Commands not in the map use their own name.
#
#   declare -A DEPS_PACKAGES=([magick]="imagemagick" [fd]="fd")
#   check_deps magick fd

check_deps() {
    local missing=()

    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    [ ${#missing[@]} -eq 0 ] && return 0

    echo -e "${RED}Error: Missing dependencies: ${missing[*]}${NC}"

    # Build package list, falling back to command name if no mapping exists
    local packages=()
    for cmd in "${missing[@]}"; do
        if declare -p DEPS_PACKAGES &>/dev/null 2>&1 && [[ -v DEPS_PACKAGES[$cmd] ]]; then
            packages+=("${DEPS_PACKAGES[$cmd]}")
        else
            packages+=("$cmd")
        fi
    done

    if command -v pacman &>/dev/null; then
        echo -ne "${YELLOW}Install with pacman? (${packages[*]}) [y/N]: ${NC}"
        read -r _answer
        if [[ "$_answer" =~ ^[Yy]$ ]]; then
            sudo pacman -S --needed "${packages[@]}" || {
                echo -e "${RED}Installation failed.${NC}"
                exit 1
            }
            return 0
        fi
    else
        echo -e "${YELLOW}Install manually: ${packages[*]}${NC}"
    fi

    exit 1
}
