#!/bin/bash

CWD=$(dirname `realpath "$0"`)

# Set default values for optional variables
lang="en"
output_video=""
DISABLE_CACHE=0

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    
    case $key in
        -u|--url)
            URL="$2"
            shift # past argument
            shift # past value
        ;;
        -l|--lang)
            lang="$2"
            shift # past argument
            shift # past value
        ;;
        -f|--subs-file)
            output_video="$2"
            shift # past argument
            shift # past value
        ;;
        -c|--disable-cache)
            DISABLE_CACHE=1
            shift
        ;;
        *) # unknown option
            # Check if the first positional argument is a valid URL
            if [[ "$1" == http* ]]; then
                url="$1"
                shift # past argument
            else
                echo "Unknown option: $1"
                exit 1
            fi
    esac
done

# Check if required variables are present
if [ -z "$URL" ]; then
    echo "URL is a required parameter."
    exit 1
fi

# If output_video is not provided, create a unique filename in /tmp directory
if [ -z "$output_video" ]; then
    id=$(date +"%Y%m%d_%H%M%S_$(uuidgen)")
    output_video="/tmp/$id"
fi

ID="$(echo -n "$URL" | md5sum | cut -d' ' -f1)"
CACHE_DIR="get-youtube-subs"

data=`bash "$CWD/../scripts/cache-get.sh" --id "$ID" --cache-dir "$CACHE_DIR"`

if [ ! -z "$data" ]; then
    echo "$data"
    exit 0
fi

# TODO: check if there is any subtitles
# yt-dlp --list-subs "$URL"
# Download subtitles and extract text
yt-dlp -q --write-auto-sub --write-sub --sub-lang "$lang" --sub-format ttml --skip-download "$URL" -o "$output_video"
subs_file="$output_video.$lang.ttml"
data=`grep '<p' "$subs_file" | sed 's/<[^>]*>//g' | python3 -c "import html; import sys; sys.stdout.buffer.write(''.join([html.unescape(line) for line in sys.stdin]).encode('utf-8'))"`
if [ -f "$subs_file" ]; then
    rm "$subs_file"
fi

if [ $DISABLE_CACHE -eq 0 ]; then
    bash "$CWD/../scripts/cache-set.sh" --id "$ID" --cache-dir "get-youtube-subs" "$data"
fi
