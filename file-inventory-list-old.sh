#!/bin/bash

# Input file containing a list of filenames
file_list="files.txt"

# Input file containing a list of servers
server_list="server.txt"

# Output file name
output_file="report.csv"

# Remove the output file if it already exists
rm -f "$output_file"

# Read the server names from the server.txt file
mapfile -t servers < "$server_list"

# Function to retrieve file permissions in rwxrwxrwx format
get_permissions() {
  local file=$1
  local ssh_output

  # SSH command to retrieve file permissions using ls -l
  ssh_output=$(ssh "$server" "ls -l \"$file\"")

  # Extract the permissions field from the ls -l output
  local permissions=$(echo "$ssh_output" | awk '{print $1}')

  echo "$permissions"
}

# Iterate over the servers
for server in "${servers[@]}"; do
  echo "Processing $server..."

  # Open a new file descriptor for the file list
  exec 3< "$file_list"

  # Iterate over the files in the file list using file descriptor 3
  while IFS= read -r -u 3 filename; do
    echo "Checking $filename on $server..."

    # SSH command to retrieve last modified date using ls -l
    ssh_output=$(ssh "$server" "ls -l --time-style=long-iso \"$filename\"")

    if [[ $? -eq 0 ]]; then
      permissions=$(get_permissions "$filename")
      modified_date=$(echo "$ssh_output" | awk '{print $6, $7}')

      echo "$server,$filename,$permissions,$modified_date" >> "$output_file"
    else
      echo "File not found: $filename" >> "$output_file"
    fi
  done

  # Close the file descriptor for the file list
  exec 3<&-

  echo "Finished processing $server."
done

echo "Report generated successfully in $output_file."

