#!/bin/sh

CWD=$(dirname `realpath "$0"`)
export $(cat "$CWD/.env" | grep -vE ".+?#.+" | xargs)

url="https://www.googleapis.com/youtube/v3/search?key=$GOOGLE_API_KEY_YOUTUBE_SEARCH&channelId=$CHANNEL_ID&part=snippet,id&maxResults=10&type=video"

random_index=$(shuf -i 0-9 -n 1)
video_id=$(curl -s "$url" | jq -r ".items[$random_index].id.videoId")

curl -s http://localhost:7531?play_url=https://youtube.com/watch?v=$video_id
