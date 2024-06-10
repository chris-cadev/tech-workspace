#!/bin/bash -e
# Function to print the usage of the script
usage() {
  echo "Usage: $0 input_file output_file crop"
  echo "Example: $0 input.mp4 output.mp4 'in_w:in_h-100'"
  exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
  echo "Error: Incorrect number of arguments"
  usage
fi

# Assign input parameters to variables
input="$1"
output="$2"
crop="$3"

# Check if the input file exists
if [ ! -f "$input" ]; then
  echo "Error: Input file '$input' does not exist"
  exit 1
fi

# Run the ffmpeg command with the provided parameters
ffmpeg -i "$input" -filter:v "crop=$crop" -c:a copy "$output"

# Check if the ffmpeg command succeeded
if [ $? -eq 0 ]; then
  echo "Video successfully cropped and saved to '$output'"
else
  echo "Error: ffmpeg command failed"
  exit 1
fi