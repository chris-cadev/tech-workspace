#!/bin/bash

# Check if the user provided a URL
if [ -z "$1" ]; then
  echo "Error: No URL provided."
  exit 1
fi

# Set the URL variable
URL=$1

# Start the video player and pass the URL as an argument
vlc "$URL"


# #!/bin/bash

# # Get the input and output paths
# input_path=$1
# output_path=$2

# # Get the duration of the video in seconds and the FPS
# duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_path")
# fps=$(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=avg_frame_rate "$input_path")

# # Convert the duration to an integer
# duration=$(printf "%.0f" "$duration")

# # Calculate the number of steps based on the FPS
# steps=$(echo "$fps / 1" | bc)

# # Prompt the user to select the start time using a slider
# start_time=$(zenity --scale --title="Select Start Time" --text="Move the slider to select the start time of the video. The current start time will be displayed in the label below the slider." --min-value=0 --max-value="$duration" --value=0 --step="$steps")

# # Prompt the user to select the end time using a slider
# end_time=$(zenity --scale --title="Select End Time" --text="Move the slider to select the end time of the video. The current end time will be displayed in the label below the slider." --min-value=0 --max-value="$duration" --value="$duration" --step="$steps")

# # Calculate the duration (in seconds) of the selected portion
# duration=$((end_time - start_time))

# # Use ffmpeg to cut the video
# echo ffmpeg -i "$input_path" -ss "$start_time" -t "$duration" -c copy "$output_path"
