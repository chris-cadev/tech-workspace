#!/bin/bash

set -e

convert_seconds_to_hhmmss() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$((seconds / 60 % 60))
    local seconds=$((seconds % 60))
    printf "%02d:%02d:%02d" $hours $minutes $seconds
}


youtube_url=$1
time_query_param=$(echo "$youtube_url" | grep -oE 't=([^&]+)')
# screenshot_time=$(python -c "from urllib.parse import urlparse; from urllib.parse import parse_qs; from datetime import timedelta; parsed = urlparse('$youtube_url'); time_query_param = parse_qs(parsed.query)['t'][0]; print(timedelta(seconds=int(time_query_param)))")
screenshot_time=$(convert_seconds_to_hhmmss "$time_query_param")
output_file="$(yt-dlp --get-title "$youtube_url")_$screenshot_time"
output_file=`echo "$output_file" | sed 's/[^[:alnum:][:space:]._-]//g'`
output_file="$HOME/Pictures/$output_file.png"

ffmpeg -ss "$screenshot_time" -i "$(yt-dlp -f b --get-url "$youtube_url")" -vframes 1 -q:v 2 "$output_file" -hide_banner -loglevel error
if [[ -f $output_file ]]; then
   open "$output_file" &
fi
