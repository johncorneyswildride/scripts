#!/usr/bin/env bash

# Check if a folder argument is provided, otherwise default to current directory
folder="${1:-.}"

# Initialize variables
file_count=0
total_runtime=0

# Check if the folder exists
if [[ ! -d "$folder" ]]; then
  echo "The folder '$folder' does not exist."
  exit 1
fi

# Loop through all .md files in the specified folder
for file in "$folder"/*.md; do
  if [[ -f "$file" ]]; then
    # Extract runtime using grep and awk, assuming format is "Runtime: X minutes"
    runtime=$(grep -oP 'Runtime:\s*\K[0-9.]+(?=\s*minutes)' "$file")
    
    if [[ -n "$runtime" ]]; then
      # Increment the file count
      ((file_count++))
      # Add the runtime to the total
      total_runtime=$(echo "$total_runtime + $runtime" | bc)
    fi
  fi
done

# Check if we have any files processed
if [[ $file_count -gt 0 ]]; then
  # Calculate average runtime
  avg_runtime=$(echo "$total_runtime / $file_count" | bc -l)
  printf "Total runtime: %.1f minutes\n" $total_runtime
  printf "Average runtime: %.1f minutes\n" $avg_runtime
else
  echo "No files found with runtime data."
fi

