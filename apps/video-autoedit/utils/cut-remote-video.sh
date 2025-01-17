#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 <YouTube URL> [start_time] [end_time] [-o output_file]"
  echo "Examples:"
  echo "  $0 https://youtu.be/n_vWDdqnnfE?t=1081"
  echo "  $0 https://youtu.be/n_vWDdqnnfE 17:58 18:29"
  echo "  $0 https://youtu.be/n_vWDdqnnfE 17:58 18:29 -o custom_output.mp4"
  exit 1
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  usage
fi

# Parse arguments
URL=$1
START=""
END=""
OUTPUT_CLIP="youtube_clip_extractor.mp4"

# Shift arguments to handle optional flags
shift

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--output)
      OUTPUT_CLIP="$2"
      shift 2
      ;;
    *)
      if [[ -z "$START" && "$1" =~ ^[0-9]+:[0-9]+$ ]]; then
        START=$1
      elif [[ -z "$END" && "$1" =~ ^[0-9]+:[0-9]+$ ]]; then
        END=$1
      else
        echo "Invalid argument: $1"
        usage
      fi
      shift
      ;;
  esac
done

if [[ "$URL" =~ \?t=([0-9]+)$ ]]; then
  SECONDS=${BASH_REMATCH[1]}
  START=$(date -u -d @"$SECONDS" +%H:%M:%S)
fi

# Ensure yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
  echo "Error: yt-dlp is not installed."
  exit 1
fi

# Check if start and end times are provided
if [ -z "$START" ] || [ -z "$END" ]; then
  echo "Error: Both start_time and end_time must be provided."
  usage
fi

# Format the time range for yt-dlp
START_SECONDS=$(echo "$START" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
END_SECONDS=$(echo "$END" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
DURATION=$((END_SECONDS - START_SECONDS))
TIME_RANGE="${START_SECONDS}-${END_SECONDS}"

# Download the specific section of the video
yt-dlp --download-sections "*${TIME_RANGE}" -o "$OUTPUT_CLIP" "$URL"

# Verify download success
if [ $? -ne 0 ]; then
  echo "Error: Failed to download the specified section."
  exit 1
fi

echo "Clip saved as $OUTPUT_CLIP."
