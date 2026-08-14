#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

usage() {
    cat <<EOF
Usage:
  $SCRIPT_NAME [--dry-run] <destination>

Back up persistent user data to an external destination.

Persistent data:
  ~/Documents
  ~/Pictures
  ~/Music
  ~/Videos

Options:
  --dry-run    Show what would be copied without modifying the destination.
  -h, --help   Show this help message.
EOF
}

DRY_RUN=false
DESTINATION=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Error: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            if [[ -n "$DESTINATION" ]]; then
                echo "Error: multiple destinations specified." >&2
                usage >&2
                exit 2
            fi

            DESTINATION="$1"
            shift
            ;;
    esac
done

if [[ -z "$DESTINATION" ]]; then
    echo "Error: backup destination is required." >&2
    usage >&2
    exit 2
fi

if [[ "$DESTINATION" == "/" ]]; then
    echo "Error: refusing to use / as backup destination." >&2
    exit 2
fi

if [[ ! -d "$DESTINATION" ]]; then
    echo "Error: destination does not exist: $DESTINATION" >&2
    exit 1
fi

DESTINATION="$(realpath "$DESTINATION")"

SOURCE_DIRECTORIES=(
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Music"
    "$HOME/Videos"
)

echo "========================================"
echo " Wolf Workstation - User Data Backup"
echo "========================================"
echo
echo "Destination:"
echo "  $DESTINATION"
echo
echo "Sources:"

for source in "${SOURCE_DIRECTORIES[@]}"; do
    echo "  $source"
done

echo

RSYNC_OPTIONS=(
    -a
    --human-readable
    --info=progress2
)

if [[ "$DRY_RUN" == true ]]; then
    RSYNC_OPTIONS+=(--dry-run)
    echo "DRY RUN: no files will be modified."
    echo
fi

for source in "${SOURCE_DIRECTORIES[@]}"; do
    if [[ ! -d "$source" ]]; then
        echo "Skipping missing directory: $source"
        continue
    fi

    directory_name="$(basename "$source")"
    target="$DESTINATION/$directory_name"

    mkdir -p "$target"

    echo "Backing up: $source"
    echo "        to: $target"

    rsync "${RSYNC_OPTIONS[@]}" "$source/" "$target/"
    echo
done

echo "Backup complete."
