#!/bin/bash

# Change the path to your server list file
SERVER_LIST="server_list.txt"

# Change the parent path to the output directory
OUTPUT_PARENT_DIR="/root/sar-reports"

# Read the server names from the server list file
while read server; do
  # Generate the server-specific output directory
  SERVER_OUTPUT_DIR="$OUTPUT_PARENT_DIR/$server"
  mkdir -p "$SERVER_OUTPUT_DIR"

  # Loop over each sa file in the /var/log/sa directory
  for FILE in $(ssh $server "ls /var/log/sa/sa[0-9][0-9]"); do
    # Get the date from the filename
    DATE=$(basename "$FILE" | sed 's/sa//')

    # Generate the output file name based on the server name and date
    output_file="$SERVER_OUTPUT_DIR/${DATE}.cpuutilization.txt"

    # Run sar command and append the output to the output file
    ssh $server "sar -u -f $FILE" >> "$output_file"

    echo "CPU usage for $server on $DATE saved to $output_file"
  done
done < "$SERVER_LIST"

