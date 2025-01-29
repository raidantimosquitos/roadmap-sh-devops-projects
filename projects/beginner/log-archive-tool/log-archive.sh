#!/bin/bash

# Check if the required number of arguments is provided
if [ -z "$1" ]; then
    echo "Error: Please provide the directory where to export the logs as an argument."
  exit 1
fi

logs_dir="$1"

# Check if the provided argument is a directory and exists
if [ ! -d $logs_dir ]; then
  echo "Error: '$logs_dir' is not a directory or does not exist."
  exit 1
fi

# Define the source and output directories
full_path=$(realpath $0)
source_path=$(dirname $full_path)
source_dir="${source_path}/log"
output_dir="${source_path}/${logs_dir}"

# Get current date and time
timestamp=$(date "+%Y%m%d_%H%M%S")

# Create tar archive with timestamp in filename
tar -czf "${output_dir}/logs_archive_${timestamp}.tar.gz" --absolute-names "${source_dir}"

echo "Logs in directory $source_dir compressed and stored successfully in $output_dir"
