#!/bin/bash

CWD=$(dirname `realpath "$0"`)

yt_dlp_subs=$(realpath "$CWD/../../bin/yt-dlp-subs")

"$yt_dlp_subs" --url "$(bash "$CWD/last-played-url.sh")" $@
