#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))
REPO_COPIES_DIR="$CWD/../.cache/repo-cloud-archive"

log_file="$CWD/backup.log"
NO_DRY_RUN=0

log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $message" | tee -a "$log_file"
}

error_exit() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ERROR] $message" | tee -a "$log_file" >&2
    exit 1
}

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-dry-run)
            NO_DRY_RUN=1
            shift
        ;;
        *)
            DIR_TO_ARCHIVE="$1";
            shift
        ;;
    esac
done
DIR_TO_ARCHIVE="$(realpath "${DIR_TO_ARCHIVE:-"."}")"
repo_name="$(basename "$DIR_TO_ARCHIVE")"

log "Starting backup for $repo_name"

if ! [ -d "$DIR_TO_ARCHIVE/.git" ]; then
    error_exit "$repo_name is not a git repository. Exiting."
fi

if [[ ! "$DIR_TO_ARCHIVE" == */ ]]; then
    DIR_TO_ARCHIVE="$DIR_TO_ARCHIVE/"
fi

repo_copy_path="$REPO_COPIES_DIR/$repo_name"

log "Creating backup directory: $repo_copy_path"
mkdir -p "$repo_copy_path" || error_exit "Failed to create backup directory"

log "Syncing repository to backup location"
rsync -aP --exclude 'node_modules' "$DIR_TO_ARCHIVE" "$repo_copy_path" || error_exit "Failed to sync repository"

log "Cleaning untracked files in $repo_copy_path"
git -C "$repo_copy_path" clean -fdX || error_exit "Failed to clean untracked files"

log "Removing .git directory"
rm -rf "$repo_copy_path/.git" || error_exit "Failed to remove .git directory"

log "Creating encrypted backup"
[[ $NO_DRY_RUN == 1 ]] && FLAG="--no-dry-run" || FLAG=""
"$CWD/cloud-archive.sh" $FLAG "$repo_copy_path" || error_exit "Failed to create encrypted backup"

log "Backup completed successfully for $repo_name"