#!/bin/sh

CWD=$(dirname `realpath "$0"`)

# Parse command line arguments
while [ $# -gt 0 ]; do
    case $1 in
        --cache-dir)
            CACHE_DIR=$2
            shift
        ;;
        --id)
            ID=$2
            shift
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

if ! [ -z "$CACHE_DIR" ]; then
    exit 0
fi

CACHE_FILE="$CACHE_DIR/$ID"
if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
fi