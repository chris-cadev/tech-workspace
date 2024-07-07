#!/bin/bash

set -e
CWD=$(dirname $(realpath "$0"))
WD="$CWD"
LOG_COMMAND="$CWD/../common-utils/log.sh"

persisted_log_file_path="$CWD/.tmp_log_file"
if [[ -f $persisted_log_file_path ]]; then
    [[ -f "`cat $persisted_log_file_path`" ]] && rm "`cat $persisted_log_file_path`"
fi

"$CWD/stop.sh" ".last-pid"

if ! [[ -f "$CWD/.env" ]]; then
    echo "$CWD/.env file does not exists"
    exit 1
fi
export $(cat "$CWD/.env" | xargs)

search=$(shuf -n 1 "$WD/possible-searches.txt")
prev_search=$(cat "$WD/.prev" | tail -n 1 | awk -F ":::" '{print $1}')

while [ "$search" = "$prev_search" ]; do
    search=$(shuf -n 1 "$WD/possible-searches.txt")
done

search=$(printf %s "$search" | jq -s -R -r @uri)

echo "searching for '$search'..." | "$LOG_COMMAND" "flow-state.start"
echo "https://www.googleapis.com/youtube/v3/search?part=id&maxResults=1&q=$search&type=video" | "$LOG_COMMAND" "flow-state.start"

video_id="$(curl --silent "https://www.googleapis.com/youtube/v3/search?part=id&maxResults=1&q=$search&type=video&key=$GOOGLE_API_KEY_YOUTUBE_SEARCH" | jq -r '.items[0].id.videoId')"
video_url="https://www.youtube.com/watch?v=$video_id"

echo "'$video_url' about to play..." | "$LOG_COMMAND" "flow-state.start"
echo "$search:::$video_url" >> "$WD/.prev"

temp_log_file=$(mktemp)
echo $temp_log_file > $persisted_log_file_path
nohup mpv "$video_url" --cache-secs=1 --no-pause --no-resume-playback --no-video --ytdl-format="bestaudio" --loop --volume=$FLOW_STATE_VOLUME > "$temp_log_file" 2>&1 &
mpv_pid=$!
echo "$mpv_pid" > "$CWD/.last-pid"
tail -f "$temp_log_file" | while read line; do
    if ! [[ "$line" =~ (AV|A):\ [0-9]{2}:[0-9]{2}:[0-9]{2}\ \/ ]]; then
        "$LOG_COMMAND" "flow-state.start" "$line"
    fi
done &
