#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# This script downloads a video from a YouTube channel (via yt-dlp), filters
# by date/title if requested, caches the downloaded file, and plays it with mpv.
# Optionally, it can stream via a direct URL to mpv (preserving position).
###############################################################################

###############################################################################
# GLOBALS & DEFAULTS
###############################################################################
CWD="$(dirname "$(realpath "$0")")"
CACHE_FOLDER="$CWD/../.cache/$(basename "$0")"
LOG_FILE="$CWD/../.logs/$(basename "$0").log"

CHANNEL_URL=""
TITLE_KEYWORD=""
MAX_DOWNLOADS="1"
DATE_AFTER=""
STREAM_MODE="false"

# Default DATE_AFTER of "1 day ago" for macOS (Darwin) vs Linux
if [[ "$(uname)" == "Darwin" ]]; then
  DATE_AFTER="$(date -v -1d +%Y%m%d)"
else
  DATE_AFTER="$(date -d '1 day ago' +%Y%m%d)"
fi

###############################################################################
# LOGGING
###############################################################################
log() {
  local message="$1"
  echo "[INFO  $(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

error() {
  local message="$1"
  echo "[ERROR $(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

###############################################################################
# USAGE
###############################################################################
usage() {
  cat <<EOF
Usage:
  $(basename "$0") <channel URL> [OPTIONS]

Required:
  <channel URL>             URL of the YouTube channel
                            (e.g., https://www.youtube.com/@nprmusic)

Options:
  --title <keyword>         Filter videos by title keyword (default: no filter)
  --max-downloads <number>  Maximum number of videos to download or stream
                            (default: 1)
  --date-after <YYYYMMDD>   Only include videos uploaded after this date
                            (default: 1 day ago)
  --stream                  Stream directly using the video's URL.
                            (Preserves watch-later position in mpv,
                             but bypasses local caching.)

Examples:
  # Download & play the first Tiny Desk Concert posted after 2025-01-01
  $(basename "$0") "https://www.youtube.com/@nprmusic" \\
    --title "Tiny Desk Concert" \\
    --max-downloads 1 \\
    --date-after 20250101

  # Stream (no caching), with watch-later position
  $(basename "$0") "https://www.youtube.com/@nprmusic" \\
    --title "Tiny Desk Concert" \\
    --stream
EOF
  exit 1
}

###############################################################################
# ARGUMENT PARSING
###############################################################################
parse_args() {
  if [[ $# -lt 1 ]]; then
    usage
  fi

  CHANNEL_URL="$1"
  shift

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --title)
        [[ -z "${2:-}" ]] && { error "Missing keyword after --title."; usage; }
        TITLE_KEYWORD="$2"
        shift 2
        ;;
      --max-downloads)
        [[ -z "${2:-}" ]] && { error "Missing integer after --max-downloads."; usage; }
        [[ ! "${2:-}" =~ ^[0-9]+$ ]] && { error "Invalid integer for --max-downloads: '$2'"; usage; }
        MAX_DOWNLOADS="$2"
        shift 2
        ;;
      --date-after)
        [[ ! "${2:-}" =~ ^[0-9]{8}$ ]] && { error "Invalid date format for --date-after. Expected YYYYMMDD."; usage; }
        DATE_AFTER="$2"
        shift 2
        ;;
      --stream)
        STREAM_MODE="true"
        shift
        ;;
      *)
        error "Unknown option: $1"
        usage
        ;;
    esac
  done
}

###############################################################################
# BUILD YT-DLP COMMAND (DOWNLOAD MODE)
###############################################################################
build_yt_dlp_command() {
  local output_template="$1"
  local cmd="yt-dlp"
  cmd+=" --dateafter '$DATE_AFTER'"
  cmd+=" --lazy-playlist"
  cmd+=" --break-on-reject"
  cmd+=" --max-downloads '$MAX_DOWNLOADS'"
  cmd+=" --restrict-filenames"
  cmd+=" -o '$output_template'"
  cmd+=" '$CHANNEL_URL'"

  if [[ -n "$TITLE_KEYWORD" ]]; then
    cmd+=" --match-title '$TITLE_KEYWORD'"
  fi

  echo "$cmd"
}

###############################################################################
# BUILD YT-DLP COMMAND (STREAM MODE: GET URL)
###############################################################################
build_yt_dlp_stream_url_command() {
  local cmd="yt-dlp"
  cmd+=" --dateafter '$DATE_AFTER'"
  cmd+=" --lazy-playlist"
  cmd+=" --break-on-reject"
  cmd+=" --max-downloads '$MAX_DOWNLOADS'"
  cmd+=" --restrict-filenames"
  cmd+=" --get-url"
  cmd+=" '$CHANNEL_URL'"

  if [[ -n "$TITLE_KEYWORD" ]]; then
    cmd+=" --match-title '$TITLE_KEYWORD'"
  fi

  echo "$cmd"
}

###############################################################################
# DOWNLOAD OR SKIP (CACHE CHECK)
###############################################################################
download_or_skip_video() {
  # 1) Generate a cache key using a hash of the command arguments
  local cache_key
  cache_key="$(echo -n "${CHANNEL_URL}_${TITLE_KEYWORD}_${DATE_AFTER}_${MAX_DOWNLOADS}" | sha256sum | cut -c1-16)"

  # 2) Check if a file with this cache key already exists
  local cached_file
  cached_file="$(ls -1A "${CACHE_FOLDER}"/*."[${cache_key}]."* 2>/dev/null | head -n1 || true)"

  if [[ -n "$cached_file" ]]; then
    log "Cache hit: Found existing file for cache key [${cache_key}] - $cached_file"
    echo "$cached_file"
    return 0
  fi

  # 3) Build custom output template using the cache key
  local output_template="${CACHE_FOLDER}/%(upload_date)s.%(title).80B.%(uploader)s.[%(id)s].[${cache_key}].%(ext)s"
  local cmd
  cmd="$(build_yt_dlp_command "$output_template")"

  log "Downloading from channel: $CHANNEL_URL"
  log "Command: $cmd"

  # 4) Run yt-dlp
  if ! bash -c "$cmd" >> "$LOG_FILE" 2>&1; then
    log "yt-dlp returned non-zero; checking if files were created anyway."
  fi

  # 5) Check if the file with the cache key now exists in the cache
  cached_file="$(ls -1A "${CACHE_FOLDER}"/*."[${cache_key}]."* 2>/dev/null | head -n1 || true)"
  if [[ -n "$cached_file" ]]; then
    log "Downloaded file: $cached_file"
    echo "$cached_file"
    return 0
  else
    error "Failed to find the downloaded file in cache."
    return 1
  fi
}

###############################################################################
# PLAY VIDEO WITH MPV
###############################################################################
play_video() {
  local video_file="$1"
  if [[ ! -f "$video_file" ]]; then
    error "Cannot play. File not found: $video_file"
    return 1
  fi
  log "Playing video: $video_file"
  if ! mpv --save-position-on-quit "$video_file"; then
    error "Failed to play video with mpv."
    return 1
  fi
}

###############################################################################
# MAIN
###############################################################################
main() {
  parse_args "$@"
  mkdir -p "${CACHE_FOLDER}"
  mkdir -p "$(dirname "$LOG_FILE")"

  if [[ "$STREAM_MODE" == "true" ]]; then
    ###########################################################################
    # STREAM MODE
    ###########################################################################
    # 1) Build a command that fetches the direct media URL (not the media bytes)
    local stream_cmd
    stream_cmd="$(build_yt_dlp_stream_url_command)"
    log "Streaming from channel: $CHANNEL_URL"
    log "Command (get-url): $stream_cmd"

    # 2) Run the command and pick the first URL in case multiple lines are returned
    #    (You could handle multiple URLs differently if you wish.)
    local stream_urls
    stream_urls="$(bash -c "$stream_cmd" 2>>/dev/null || true)"
    local video_stream_url="$(echo "$stream_urls" | sed -n '1p')"
    local audio_stream_url="$(echo "$stream_urls" | sed -n '2p')"

    if [[ -z "$stream_urls" ]]; then
      error "No valid stream URL found (yt-dlp returned nothing)."
      exit 1
    fi

    log "Got stream URLs"
    log "Video URL: $video_stream_url"
    log "Audio URL: $audio_stream_url"

    # 3) Pass that URL to mpv.
    #    mpv sees a "real" URL and can remember watch-later progress.
    if ! mpv --save-position-on-quit --audio-file="$audio_stream_url" "$video_stream_url"; then
      error "Streaming with mpv failed."
      exit 1
    fi

    log "Streaming finished successfully."
    exit 0

  else
    ###########################################################################
    # DOWNLOAD & CACHE MODE (ORIGINAL LOGIC)
    ###########################################################################
    local video_file
    if ! video_file="$(download_or_skip_video)"; then
      error "Failed to acquire a video file."
      exit 1
    fi

    log "Video file ready: $video_file"
    if ! play_video "$video_file"; then
      error "Playback failed."
      exit 1
    fi

    log "Playback finished successfully."
  fi
}

main "$@"
