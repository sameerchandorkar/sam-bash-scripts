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

  # Loop over each sa file in the /var/log/sa directory on the remote server
  ssh "$server" "for FILE in /var/log/sa/sa[0-9][0-9]; do DATE=\$(basename \"\$FILE\" | sed 's/sa//'); sar -u -f \"\$FILE\" >> \"$SERVER_OUTPUT_DIR/\$DATE.cpuutilization.txt\"; done"

  echo "CPU usage for $server saved to $SERVER_OUTPUT_DIR"
done < "$SERVER_LIST"

