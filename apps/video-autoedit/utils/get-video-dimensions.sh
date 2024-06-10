#!/bin/bash

# A script to get video dimensions using ffprobe

# Print usage information
usage() {
    echo "Usage: $0 [-j] video_file"
    echo "  -j        Output dimensions in JSON format"
    echo "  video_file  Path to the video file"
    exit 1
}

# Check if ffprobe is installed
command -v ffprobe >/dev/null 2>&1 || {
    echo "ffprobe is required but not installed. Please install it and try again."
    exit 1
}

# Function to get video dimensions in "widthxheight" format
get_video_dimensions() {
    ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0:s=x "$1"
}

# Function to get video dimensions in JSON format
get_video_dimensions_json() {
    ffprobe -v error -select_streams v -show_entries stream=width,height -of json "$1"
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    usage
fi

# Parse command-line options
while getopts ":j" opt; do
    case ${opt} in
        j )
            json_output=true
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if video file is provided
if [ $# -eq 0 ]; then
    echo "Error: No video file provided."
    usage
fi

video_file="$1"

# Check if the video file exists
if [ ! -f "$video_file" ]; then
    echo "Error: File '$video_file' not found."
    exit 1
fi

# Get and print video dimensions
if [ "$json_output" = true ]; then
    get_video_dimensions_json "$video_file"
else
    get_video_dimensions "$video_file"
fi
