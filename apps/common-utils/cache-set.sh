#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))

# Function to display help message
function show_help() {
    echo "Usage: $0 --id <ID> --cache-dir <CACHE_DIR> [--expiration <EXPIRATION>] <DATA>"
    echo
    echo "Arguments:"
    echo "  --id            Unique identifier for the cache file."
    echo "  --cache-dir     Directory where the cache file will be stored."
    echo "  --expiration    Expiration time in seconds (default: 3 weeks)."
    echo "  <DATA>          The data to be cached."
    echo
    echo "Options:"
    echo "  --help          Show this help message and exit."
}

# Parse command line arguments
while [ $# -gt 0 ]; do
    case $1 in
        --cache-dir)
            CACHE_DIR=$2
            shift 2
        ;;
        --expiration)
            EXPIRATION=$2
            shift 2
        ;;
        --id)
            ID=$2
            shift 2
        ;;
        --help)
            show_help
            exit 0
        ;;
        *)
            # If it's not a flag, assume it's the data
            if [ -z "$DATA" ]; then
                DATA=$1
                shift
            else
                echo "Unexpected argument: $1"
                show_help
                exit 1
            fi
        ;;
    esac
done

# Check required options
if [ -z "$ID" ]; then
    echo "'$0' Missing --id"
    show_help
    exit 1
fi

if [ -z "$CACHE_DIR" ]; then
    echo "'$0' Missing --cache-dir"
    show_help
    exit 1
fi

if [ -z "$DATA" ]; then
    echo "'$0' Missing data argument"
    show_help
    exit 1
fi

CACHE_DIR="$CWD/../.cache/$CACHE_DIR"
if ! [ -d "$CACHE_DIR" ]; then
  mkdir -p "$CACHE_DIR"
fi
CACHE_DIR=$(realpath "$CACHE_DIR")

if [ -z "$EXPIRATION" ]; then
    MIN_SECS=60
    HOUR_SECS=$((MIN_SECS * 60))
    DAY_SECS=$((HOUR_SECS * 24))
    THREE_WEEKS_SECS=$((DAY_SECS * 21))
    
    EXPIRATION=$THREE_WEEKS_SECS
fi

# Set cache file path
CACHE_FILE="$CACHE_DIR/$ID"
CACHE_FILE_DIR="$(dirname "$CACHE_FILE")"

if [ ! -d "$CACHE_FILE_DIR" ]; then
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

if [ "$difference" -ge "$EXPIRATION" ]; then
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

