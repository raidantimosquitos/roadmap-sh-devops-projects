#!/bin/bash

# Check if the required number of arguments is provided
if [ -z "$1" ]; then
    echo "Error: Please provide the directory where to export the logs as an argument."
  exit 1
fi

# Check if the provided argument is a directory and exists
if [ ! -d "$1" ]; then
  echo "Error: '$1' is not a directory or does not exist."
  exit 1
fi

logs_dir="$1"

# Define the source directory
source_dir="/var/log"

# Get current date and time
timestamp=$(date "+%Y%m%d_%H%M%S")

# Create tar archive with timestamp in filename
tar -czf "${logs_dir}/logs_archive_${timestamp}.tar.gz" "${source_dir}"

