#!/usr/bin/env bash

# Check if a folder argument is provided, otherwise default to current directory
folder="${1:-.}"

# Initialize variables
file_count=0
total_duration=0

# Check if the folder exists
if [[ ! -d "$folder" ]]; then
  echo "The folder '$folder' does not exist."
  exit 1
fi

# Loop through all .md files in the specified folder
for file in "$folder"/*.md; do
  if [[ -f "$file" ]]; then
    # Extract duration using grep and awk, assuming format is "Duration: X minutes"
    duration=$(grep -oP 'Duration:\s*\K[0-9.]+(?=\s*minutes)' "$file")
    
    if [[ -n "$duration" ]]; then
      # Increment the file count
      ((file_count++))
      # Add the duration to the total
      total_duration=$(echo "$total_duration + $duration" | bc)
    fi
  fi
done

# Check if we have any files processed
if [[ $file_count -gt 0 ]]; then
  # Calculate average duration
  avg_duration=$(echo "$total_duration / $file_count" | bc -l)
  printf "Total duration: %.1f minutes\n" $total_duration
  printf "Average duration: %.1f minutes\n" $avg_duration
else
  echo "No files found with duration data."
fi

