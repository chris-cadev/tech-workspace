#!/bin/sh

CWD=$(dirname `realpath "$0"`)

# Parse command line arguments
while [ $# -gt 0 ]; do
    case $1 in
        --cache-dir)
            CACHE_DIR=$2
            shift
        ;;
        --expiration)
            EXPIRATION=$2
            shift
        ;;
        --id)
            ID=$2
            shift
        ;;
        *)
            # If it's not a flag, assume it's the data
            if [ -z "$DATA" ]; then
                DATA=$1
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
        ;;
    esac
    shift
done

# Check required options
if [ -z "$ID" ]; then
    echo "'$0' Missing --id"
    exit 1
fi

if [ -z "$CACHE_DIR" ]; then
    echo "'$0' Missing --cache-dir"
    exit 1
fi

CACHE_DIR="$CWD/../.cache/$CACHE_DIR"
CACHE_DIR=$(realpath "$CACHE_DIR")

if [ -z "$EXPIRATION_TIME" ]; then
    MIN_SECS=60
    HOUR_SECS=$((MIN_SECS * 60))
    DAY_SECS=$((HOUR_SECS * 24))
    THREE_WEEKS_SECS=$((HOUR_SECS * 21))
    
    EXPIRATION_TIME=$THREE_WEEKS_SECS
fi

# Set cache file path
CACHE_FILE="$CACHE_DIR/$ID"
CACHE_FILE_DIR="$(dirname "$CACHE_FILE")"

if [ ! -d $CACHE_FILE_DIR ]; then
    mkdir -p "$CACHE_FILE_DIR"
fi

function write_cache() {
    local DATA="$1"
    local CACHE_FILE="$2"
    echo "$DATA" > "$CACHE_FILE"
    echo "$DATA"
}

# Check if cache file exists and is not expired
if [ ! -f "$CACHE_FILE" ]; then
    # Cache the data
    write_cache "$DATA" "$CACHE_FILE"
    exit 0
fi

cache_data=$(cat "$CACHE_FILE")
cache_date=$(date -r "$CACHE_FILE" +%s)
curr_date=$(date +%s)

difference=$(( curr_date - cache_date ))

if [ "$difference" -ge "$EXPIRATION_TIME" ]; then
    write_cache "$DATA" "$CACHE_FILE"
    exit 0
fi

if [ "$cache_data" = "$DATA" ]; then
    # If the cached data is the same as the new data, return the cached data
    echo "$cache_data"
else
    # If the cached data is different from the new data, replace the cache file
    write_cache "$DATA" "$CACHE_FILE"
    exit 0
fi
