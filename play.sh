#!/usr/bin/env bash

# Check if a folder argument is provided, otherwise default to current directory
folder="${1:-.}"

# Check if the folder exists
if [[ ! -d "$folder" ]]; then
  echo "The folder '$folder' does not exist."
  exit 1
fi

# Define the playlist file (playlist.txt is expected in the folder)
file_list="$folder/playlist.txt"

# Check if the playlist file exists
if [[ ! -f "$file_list" ]]; then
  echo "The file 'playlist.txt' does not exist in the folder '$folder'."
  exit 1
fi

# Initialize an array to hold the list of files
playlist=()

# Read the playlist file and construct the full paths
while IFS= read -r file; do
  # Construct the full path of the file
  full_path="$folder/$file"

  # Check if the file exists
  if [[ -f "$full_path" ]]; then
    # Add the file to the playlist array
    playlist+=("$full_path")
  else
    echo "Error: File '$full_path' not found!"
  fi
done < "$file_list"

# If we have files in the playlist, pass them all to mpv
if [[ ${#playlist[@]} -gt 0 ]]; then
  # Pass the entire playlist to mpv
  echo "Starting playback..."
  mpv "${playlist[@]}"
else
  echo "No valid files found in the playlist."
fi
