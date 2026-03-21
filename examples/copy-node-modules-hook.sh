#!/usr/bin/env bash

set -euo pipefail

: "${WT_SOURCE_PATH:?}"
: "${WT_WORKTREE_PATH:?}"

copy_dir() {
    local source="$1"
    local destination="$2"

    mkdir -p "$(dirname "$destination")"

    if cp -cR "$source" "$destination" 2>/dev/null; then
        return 0
    fi

    cp -R "$source" "$destination"
}

while IFS= read -r -d '' source; do
    relative="${source#"$WT_SOURCE_PATH"/}"
    destination="$WT_WORKTREE_PATH/$relative"

    if [ -e "$destination" ]; then
        continue
    fi

    copy_dir "$source" "$destination"
done < <(find "$WT_SOURCE_PATH" -type d -name node_modules -prune -print0)
