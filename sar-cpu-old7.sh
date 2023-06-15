#!/bin/bash

# Change the path to your server list file
SERVER_LIST="serverlist"

# Change the parent path to the output directory
OUTPUT_PARENT_DIR="/root/sar-reports"

# Read the server names from the server list file
while read server; do
  # Generate the server-specific output directory
  SERVER_OUTPUT_DIR="$OUTPUT_PARENT_DIR/$server"
  mkdir -p "$SERVER_OUTPUT_DIR"

  # Loop over each sa file in the /var/log/sa directory
  for FILE in $(ssh "$server" 'ls /var/log/sa/sa[0-9]*'); do
    # Get the date from the filename
    DATE=$(basename "$FILE" | sed 's/sa//')
    # Generate the output file name based on the server name and date
    output_file="$SERVER_OUTPUT_DIR/${DATE}.cpuutilization.txt"

    # Check if the output directory exists, and create it if it doesn't
    if [ ! -d "$SERVER_OUTPUT_DIR" ]; then
      mkdir -p "$SERVER_OUTPUT_DIR"
    fi

    # Generate the output line with the date and CPU utilization
    output_line="${DATE},$(ssh "$server" "sar -u -f $FILE -s \"$(date -d '1 month ago' +%Y%m%d)\"" | tail -n1)"
    # Append the output line to the output file
    echo "$output_line" >> "$output_file"
    echo "CPU usage for $server saved to $output_file"
  done
done < "$SERVER_LIST"
