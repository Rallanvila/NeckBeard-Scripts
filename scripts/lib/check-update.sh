#!/usr/bin/env bash
# Update checker — source this file, do not execute it directly.
# Requires colors.sh to be sourced first.
#
# Fetches from origin at most once every 24 hours (timestamp cached in
# .last_update_check at the repo root). Prints a one-line notice and the
# update command when the local branch is behind upstream; silent otherwise.

check_for_update() {
    local repo_dir
    repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    # Bail out silently if this isn't a git repo
    git -C "$repo_dir" rev-parse --git-dir &>/dev/null || return 0

    local stamp_file="$repo_dir/.last_update_check"
    local now threshold last_check
    now=$(date +%s)
    threshold=$(( 60 * 60 * 24 )) # 24 hours

    if [ -f "$stamp_file" ]; then
        last_check=$(cat "$stamp_file")
        if (( now - last_check < threshold )); then
            _nb_compare_commits "$repo_dir"
            return
        fi
    fi

    # Fetch quietly; update stamp regardless of network result
    git -C "$repo_dir" fetch --quiet origin 2>/dev/null
    echo "$now" > "$stamp_file"

    _nb_compare_commits "$repo_dir"
}

_nb_compare_commits() {
    local repo_dir="$1"
    local local_sha remote_sha
    local_sha=$(git -C "$repo_dir" rev-parse HEAD 2>/dev/null)
    remote_sha=$(git -C "$repo_dir" rev-parse "@{u}" 2>/dev/null)

    if [ -n "$local_sha" ] && [ -n "$remote_sha" ] && [ "$local_sha" != "$remote_sha" ]; then
        echo -e "${YELLOW}💡 Update available! Run: ${CYAN}neckbeard update${NC} to get the latest."
    fi
}
