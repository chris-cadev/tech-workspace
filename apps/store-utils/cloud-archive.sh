#!/bin/bash -e

# Encrypts a directory, stores password in Bitwarden, and uploads it to cloud storage via rclone

VERBOSE=false
NO_DRY_RUN=false  # Por defecto, el script solo simula acciones
SCRIPT_PID="$$"

log() {
    local level="$1"
    shift
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [PID: $SCRIPT_PID] [$level] $*" | tee -a "$LOG_FILE"
}

usage() {
    echo "Usage: $0 [-v] [--no-dry-run] <directory_to_archive> [remote] [remote_directory] [bw_folder]"
    echo ""
    echo "  -v                    Enable verbose mode (detailed logs)"
    echo "  --no-dry-run          Actually execute the operations (without this flag, script runs in simulation mode)"
    echo "  directory_to_archive   The local directory to back up (default: current directory)"
    echo "  remote                The rclone remote name (default: gdrive)"
    echo "  remote_directory      The directory on the remote storage (default: '/98 - archive')"
    echo "  bw_folder             The Bitwarden folder name for storing passwords (default: '<remote>-archives')"
    echo ""
    echo "Requirements:"
    echo "  - Bitwarden CLI (bw) (logged in and unlocked)"
    echo "  - GPG"
    echo "  - rclone (logged in and working)"
    exit 1
}

check_dependencies() {
    local deps=("bw" "gpg" "rclone")
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log "ERROR" "$cmd is required but not installed. Aborting."
            exit 2
        fi
    done
}

check_bw_session() {
    log "INFO" "Checking Bitwarden session..."
    if ! bw status | jq -e '.status == "unlocked"' >/dev/null; then
        log "ERROR" "Bitwarden is either locked or not logged in. Please run 'bw login' and 'bw unlock'."
        exit 3
    fi
    log "INFO" "Bitwarden is unlocked."
}

check_rclone_connection() {
    local remote="$1"
    log "INFO" "Checking rclone connection to remote: $remote..."
    if ! rclone ls "$remote:" --max-depth 1 >/dev/null 2>&1; then
        log "ERROR" "rclone cannot access remote '$remote'. Please verify your rclone configuration."
        exit 4
    fi
    log "INFO" "rclone connection is active."
}

cleanup() {
    log "INFO" "Cleaning up temporary files..."
    [[ "$NO_DRY_RUN" == true ]] && rm -f "$TARBALL_FILE" "$TARBALL_FILE.gpg"
    log "INFO" "Cleanup complete."
}

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v) VERBOSE=true ;;
        --no-dry-run) NO_DRY_RUN=true ;;
        --help) usage ;;
        *) break ;;  # Stop parsing if a positional argument is found
    esac
    shift
done

# Set variables with defaults
DIRECTORY_TO_ARCHIVE="${1:-"$PWD"}"
LOG_FILE="$(dirname "$DIRECTORY_TO_ARCHIVE")/$(basename "$DIRECTORY_TO_ARCHIVE")-cloud-bak.log"
REMOTE="${2:-"gdrive"}"
REMOTE_DIRECTORY="${3:-"/98 - archive"}"
BW_FOLDER="${4:-"$REMOTE-archives"}"

# Resolve absolute path
DIRECTORY_TO_ARCHIVE=$(realpath "$DIRECTORY_TO_ARCHIVE")

# Logging start
log "INFO" "Backup process started for directory: $DIRECTORY_TO_ARCHIVE"
log "INFO" "Mode: $( [[ "$NO_DRY_RUN" == true ]] && echo "Executing" || echo "Dry-run (simulation)")"

# Check dependencies
check_dependencies

# Check sessions
check_bw_session
check_rclone_connection "$REMOTE"

# Validate directory
if [[ ! -d "$DIRECTORY_TO_ARCHIVE" ]]; then
    log "ERROR" "$DIRECTORY_TO_ARCHIVE is not a valid directory. Aborting."
    usage
fi

# Ensure Bitwarden folder exists
if [[ $(bw list folders --search "$BW_FOLDER" | jq '.[].id' | wc -l) == 0 ]]; then
    [[ "$NO_DRY_RUN" == true ]] && bw get template folder | jq ".name=\"$BW_FOLDER\"" | bw encode | bw create folder
fi

FOLDER_ID=$(bw list folders --search "$BW_FOLDER" | jq -r '.[].id' | head -n 1)

# Generate archive password
ARCHIVE_PASSWORD=$(bw generate --passphrase --capitalize --includeNumber --words 3)

# Store password in Bitwarden
OUTPUT_DIRECTORY=$(dirname "$DIRECTORY_TO_ARCHIVE")
OUTPUT_FILE=$(basename "$DIRECTORY_TO_ARCHIVE")
LOGIN_JSON=$(bw get template item.login | jq ".totp=\"\" | .username=\"\" | .password=\"$ARCHIVE_PASSWORD\"")

if [[ "$NO_DRY_RUN" == true ]]; then
    bw get template item | jq ".name=\"$OUTPUT_FILE ($OUTPUT_DIRECTORY)\" | .notes=\"\" | .folderId=\"$FOLDER_ID\" | .login=$LOGIN_JSON" | bw encode | bw create item
fi

# Create tarball
TARBALL_FILE="$OUTPUT_DIRECTORY/$OUTPUT_FILE.tar.gz"
log "INFO" "Creating archive: $TARBALL_FILE"

if [[ "$NO_DRY_RUN" == true ]]; then
    tar -vczf "$TARBALL_FILE" "$DIRECTORY_TO_ARCHIVE" | tee -a "$LOG_FILE"
else
    log "INFO" "[SIMULATION] Tarball would be created: $TARBALL_FILE"
fi

# Encrypt archive
log "INFO" "Encrypting archive..."

if [[ "$NO_DRY_RUN" == true ]]; then
    echo "$ARCHIVE_PASSWORD" | gpg --batch --yes --symmetric --cipher-algo AES256 --armor --passphrase-fd 0 -o "$TARBALL_FILE.gpg" "$TARBALL_FILE"
else
    log "INFO" "[SIMULATION] Archive would be encrypted: $TARBALL_FILE.gpg"
fi

# Upload archive
log "INFO" "Uploading to cloud: $REMOTE -> $REMOTE_DIRECTORY"

if [[ "$NO_DRY_RUN" == true ]]; then
    rclone copy "$TARBALL_FILE.gpg" "$REMOTE:$REMOTE_DIRECTORY"
else
    log "INFO" "[SIMULATION] File would be uploaded to: $REMOTE:$REMOTE_DIRECTORY"
fi

log "INFO" "Backup process completed. $( [[ "$NO_DRY_RUN" == true ]] && echo "Executed successfully!" || echo "Simulated execution.")"

# Cleanup
trap cleanup EXIT
