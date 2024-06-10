#!/bin/bash

url="$1"
start="$2"
end="$3"

count_time_string_numbers() {
    echo "$1" | xargs -d ':' | wc -w
}

calculate_seconds_min_sec() {
    awk -F ":" '{print $1*60+$2}'
}

calculate_seconds_hr_min_sec() {
    awk -F ":" '{print $1*60*60+$2*60+$3}'
}

calculate_seconds() {
    [ `count_time_string_numbers "$1"` -eq '1' ] && echo "$1"
    [ `count_time_string_numbers "$1"` -eq '2' ] && echo "$1" | calculate_seconds_min_sec
    [ `count_time_string_numbers "$1"` -eq '3' ] && echo "$1" | calculate_seconds_hr_min_sec
}

start_seconds=`calculate_seconds "$2"`
end_seconds=`calculate_seconds "$3"`

[ $start_seconds -gt $end_seconds ] && echo "start must be after end point to download the section correctly" && exit 1

[ -z "$4" ] && echo "write a title for the video if you want"
[ -z "$4" ] && read filename

filename=${filename:-$4}
extension="${filename##*.}"

yt-dlp "$1" --download-sections "*$start_seconds-$end_seconds" -o "$filename" --recode "$extension" --force-keyframes-at-cuts `shift;shift;shift;shift;echo $@;`
