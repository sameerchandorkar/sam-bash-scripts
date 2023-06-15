#!/bin/bash

# Change the path to your server list file
SERVER_LIST="server_list.txt"

# Change the path to the directory where you want to save the output files
OUTPUT_DIR="/root/sar-reports"

# Read the server names from the server list file
while read server; do
  # Generate the output file name based on the server name and current date
  output_file="$OUTPUT_DIR/cpu_usage_$server_$(date +%Y%m%d).txt"
  
  # Run the sar command for the last month and write the output to the output file
  ssh $server "sar -u -f /var/log/sysstat/sa[DD] -s \"$(date -d '1 month ago' +%Y%m%d)\"" > $output_file
  
  echo "CPU usage for $server saved to $output_file"
done < $SERVER_LIST
