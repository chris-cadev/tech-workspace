#!/bin/bash

# reference https://youtu.be/mtDoQDp0nj8?t=254

CWD=$(dirname `realpath "$0"`)
CACHE_DIR="$CWD/../.cache/url-title"
EXPIRATION_TIME=604800 # 1 week in seconds

URL=""
DISABLE_CACHE=0

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --disable-cache)
            DISABLE_CACHE=1
            shift
        ;;
        *)
            URL=$key
            shift
        ;;
    esac
done

if [ -z "$URL" ]; then
    read URL
fi

if [ $DISABLE_CACHE -eq 0 ]; then
    CACHE_FILE="$CACHE_DIR/$(echo -n "$URL" | md5sum | cut -d' ' -f1)"
    
    if [ ! -d "$CACHE_DIR" ]; then
        mkdir -p "$CACHE_DIR"
    fi
    
    if [ -f "$CACHE_FILE" ]; then
        cache_date=$(date -r "$CACHE_FILE" +%s)
        curr_date=$(date +%s)
        if (( curr_date - cache_date < EXPIRATION_TIME )); then
            content=$(cat "$CACHE_FILE")
            if [ ! -z "$content" ]; then
                echo $content
                exit 0
            fi
        fi
    fi
fi



TITLE=$(curl --silent "$URL" \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
    -H 'accept-language: en-US,en;q=0.6' \
    -H 'cache-control: max-age=0' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-site: same-origin' \
    -H 'sec-fetch-user: ?1' \
    -H 'sec-gpc: 1' \
    -H 'service-worker-navigation-preload: true' \
    -H 'upgrade-insecure-requests: 1' \
    --compressed \
| pup --charset UTF-8 "title text{}")

if [ $DISABLE_CACHE -eq 0 ]; then
    echo "$TITLE" > "$CACHE_FILE"
fi

echo "$TITLE"
