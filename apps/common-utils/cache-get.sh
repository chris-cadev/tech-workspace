#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))

# Function to display help message
function show_help() {
    echo "Usage: $0 --id <ID> --cache-dir <CACHE_DIR>"
    echo
    echo "Arguments:"
    echo "  --id          Unique identifier for the cache file."
    echo "  --cache-dir   Directory where the cache file will be stored."
    echo
    echo "Options:"
    echo "  --help        Show this help message and exit."
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --cache-dir)
            CACHE_DIR="$2"
            shift 2
        ;;
        --id)
            ID="$2"
            shift 2
        ;;
        --help)
            show_help
            exit 0
        ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
        ;;
    esac
done

# Check required options
if [ -z "$ID" ]; then
    echo "Error: Missing --id"
    show_help
    exit 1
fi

if [ -z "$CACHE_DIR" ]; then
    echo "Error: Missing --cache-dir"
    show_help
    exit 1
fi

CACHE_DIR="$CWD/../.cache/$CACHE_DIR"
if ! [ -d "$CACHE_DIR" ]; then
    echo "Cache directory does not exist: $CACHE_DIR"
    exit 0
fi
CACHE_DIR=$(realpath "$CACHE_DIR")

CACHE_FILE="$CACHE_DIR/$ID"
if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
fi

