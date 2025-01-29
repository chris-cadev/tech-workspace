#!/bin/bash

# Function to log messages
log() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

# Function to display usage
usage() {
    cat << EOF
Usage: $(basename $0) <url> <start_time> <end_time> [title] [additional_args...]

Arguments:
  <url>              The URL of the video to download.
  <start_time>       The start time of the segment (format: HH:MM:SS, MM:SS, or seconds).
  <end_time>         The end time of the segment (format: HH:MM:SS, MM:SS, or seconds).
  [title]            (Optional) The output file name.
  [additional_args]  (Optional) Additional arguments to pass to yt-dlp.

Example:
  $0 "https://example.com/video" 00:01:00 00:02:00 "output.mp4"
EOF
}

# Input parameters
url="$1"
start="$2"
end="$3"
title="$4"
shift 4
additional_args="$@"

# Validate inputs
if [ -z "$url" ] || [ -z "$start" ] || [ -z "$end" ]; then
    usage
    exit 1
fi

# Function to count colon-separated components in a time string
count_time_string_numbers() {
    echo "$1" | awk -F':' '{print NF}'
}

# Convert time strings to seconds
calculate_seconds_min_sec() {
    awk -F":" '{print $1*60+$2}'
}

calculate_seconds_hr_min_sec() {
    awk -F":" '{print $1*3600+$2*60+$3}'
}

calculate_seconds() {
    local count=$(count_time_string_numbers "$1")
    if [ "$count" -eq 1 ]; then
        echo "$1"
    elif [ "$count" -eq 2 ]; then
        echo "$1" | calculate_seconds_min_sec
    elif [ "$count" -eq 3 ]; then
        echo "$1" | calculate_seconds_hr_min_sec
    else
        log "ERROR" "Invalid time format: $1"
        exit 1
    fi
}

log "INFO" "Calculating start and end times in seconds."
start_seconds=$(calculate_seconds "$start")
end_seconds=$(calculate_seconds "$end")

# Validate time range
if [ "$start_seconds" -ge "$end_seconds" ]; then
    log "ERROR" "Start time must be less than end time."
    exit 1
fi

# Prompt for a filename if not provided
if [ -z "$title" ]; then
    log "INFO" "No title provided. Prompting user for filename."
    echo "Enter a title for the video: "
    read -r title
    if [ -z "$title" ]; then
        log "ERROR" "No filename provided."
        exit 1
    fi
fi

# Determine file extension
extension="${title##*.}"
if [ -z "$extension" ] || [ "$extension" == "$title" ]; then
    log "INFO" "No extension detected. Using default: mp4."
    extension="mp4"
    title="$title.$extension"
fi

log "INFO" "Downloading video segment: $start_seconds to $end_seconds seconds."
log "INFO" "Output file: $title"

# Run yt-dlp command
yt-dlp "$url" \
    --download-sections "*$start_seconds-$end_seconds" \
    -o "$title" \
    --recode "$extension" \
    --force-keyframes-at-cuts $additional_args

if [ $? -ne 0 ]; then
    log "ERROR" "yt-dlp failed to download or process the video."
    exit 1
fi

log "INFO" "Video successfully downloaded and saved as $title."
log "INFO" "Script completed."
