#!/bin/bash

set -e

video=`realpath "$1"`
video_location=`dirname "$video"`
video_name=`basename "$video"`
video_name="${video_name%.*}"
gif_default_output="$video_location/$video_name.gif"

scale=${2:-"500"}
gif_output="${3:-$gif_default_output}"

ffmpeg -i "$video" -vf "fps=10,scale=$scale:-1:flags=lanczos" "$gif_output"
