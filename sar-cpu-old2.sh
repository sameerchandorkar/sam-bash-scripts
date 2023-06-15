#!/bin/bash

# Change the path to your server list file
SERVER_LIST="server_list.txt"

# Change the path to the directory where you want to save the output files
OUTPUT_DIR="/root/sar-reports"

# Read the server names from the server list file
while read server; do
  # Loop over each sa file in the /var/log/sysstat directory
  for FILE in /var/log/sa/sa[0-9][0-9]; do
    # Get the date from the filename
    DATE=$(basename "$FILE" | sed 's/sa//')
    # Generate the output file name based on the server name and the date from the filename
    output_file="$OUTPUT_DIR/cpu_usage_${server}_${DATE}.txt"
    # Run the sar command for the last month and write the output to the output file
    #ssh $server "sar -u -f $FILE -s \"$(date -d '1 month ago' +%Y%m%d)\"" > $output_file
    ssh $server "sar -u -f $FILE" >> $output_file
    echo "CPU usage for $server on $DATE saved to $output_file"
  done
done < $SERVER_LIST

