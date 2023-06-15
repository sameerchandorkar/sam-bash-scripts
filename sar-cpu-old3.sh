#!/bin/bash

# Change the path to your server list file
SERVER_LIST="server_list.txt"

# Change the path to the output directory
OUTPUT_DIR="/root/sar-reports"

# Read the server names from the server list file
while read server; do
  # Generate the output file name based on the server name
  output_file="$OUTPUT_DIR/${server}_cpuutilization.csv"

  # Loop over each sa file in the /var/log/sa directory
  for FILE in /var/log/sa/sa[0-9][0-9]; do
    # Get the date from the filename
    DATE=$(basename "$FILE" | sed 's/sa//')
    # Generate the output line with the date and CPU utilization
    output_line="${DATE},$(ssh $server "sar -u -f $FILE -s \"$(date -d '1 month ago' +%Y%m%d)\"" | tail -n1)"
    # Append the output line to the output file
    echo $output_line >> $output_file
    echo "CPU usage for $server on $DATE saved to $output_file"
  done
done < $SERVER_LIST

