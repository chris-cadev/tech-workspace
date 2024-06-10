#!/bin/bash

# Replace forbidden characters in filenames with emoji alternatives

# Specify the directory to scan
dir="$1"

# Find all files with forbidden characters in their names
find "$dir" -regex '.*[\\|/:\*\?"<>].*' -print0 | while IFS= read -r -d '' file; do
  # Extract the file name and directory path
  filename=$(basename "$file")
  dirname=$(dirname "$file")
  # Replace the forbidden characters in the file name with emoji alternatives
  new_name=$(echo "$filename" | tr '\\|/:*?"<>' '\\|/:*?"<>' )
  # Construct the new file path
  new_path="$dirname/$new_name"
  # Rename the file
  mv "$file" "$new_path"
done
