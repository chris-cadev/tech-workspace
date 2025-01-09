#!/bin/bash

# Default values for optional arguments
TITLE_KEYWORD=""
MAX_DOWNLOADS=1
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS/BSD systems
    DATE_AFTER=$(date -v -1d +%Y%m%d)
else
    # Linux systems
    DATE_AFTER=$(date -d '1 day ago' +%Y%m%d)
fi

# Log function for better output formatting
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to display usage instructions
usage() {
    cat << EOF
Usage: $0 <channel URL> [OPTIONS]

Required:
  <channel URL>           URL of the YouTube channel (e.g., https://www.youtube.com/@nprmusic)

Options:
  --title <keyword>       Filter videos by title keyword (default: no filter)
  --max-downloads <num>   Maximum number of videos to download (default: 1)
  --date-after <YYYYMMDD> Only include videos uploaded after this date (default: 1 day ago)

Example:
  $0 "https://www.youtube.com/@nprmusic" --title "Tiny Desk Concert" --max-downloads 1 --date-after 20240101
EOF
    exit 1
}

# Ensure at least the channel URL is provided
if [ "$#" -lt 1 ]; then
    usage
fi

# Assign the required parameter
CHANNEL_URL="$1"
shift

# Parse optional flags
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --title)
            if [ -z "$2" ]; then
                log "Error: --title flag requires a keyword."
                usage
            fi
            TITLE_KEYWORD="$2"
            shift 2
            ;;
        --max-downloads)
            if ! [[ "$2" =~ ^[0-9]+$ ]]; then
                log "Error: --max-downloads flag requires a valid number."
                usage
            fi
            MAX_DOWNLOADS="$2"
            shift 2
            ;;
        --date-after)
            if ! [[ "$2" =~ ^[0-9]{8}$ ]]; then
                log "Error: --date-after flag requires a date in YYYYMMDD format."
                usage
            fi
            DATE_AFTER="$2"
            shift 2
            ;;
        *)
            log "Error: Unknown option '$1'."
            usage
            ;;
    esac
done

# Build the base yt-dlp command
CMD="yt-dlp --dateafter $DATE_AFTER --lazy-playlist --break-on-reject --max-downloads \"$MAX_DOWNLOADS\" -o - \"$CHANNEL_URL\""

# Add the --match-title option if TITLE_KEYWORD is provided
if [ -n "$TITLE_KEYWORD" ]; then
    CMD+=" --match-title \"$TITLE_KEYWORD\""
fi

# Log and run the command
log "Running yt-dlp with the following parameters:"
log "  Channel URL   : $CHANNEL_URL"
log "  Title keyword : ${TITLE_KEYWORD:-<none>}"
log "  Max downloads : $MAX_DOWNLOADS"
log "  Date after    : $DATE_AFTER"

log "Executing command: $CMD"
eval $CMD | mpv - || {
    log "Error: Failed to execute yt-dlp or mpv."
    exit 1
}

log "Playback finished successfully."
