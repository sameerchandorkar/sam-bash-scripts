#!/bin/bash

# Create the server_output directory if it doesn't exist
if [ ! -d "sar-reports" ]; then
    mkdir sar-reports
fi

# Define the file containing the server list
SERVERLIST="serverlist"

# Define the location to store the reports
REPORT_DIR=./sar-reports

# Loop through the servers in the server list
while read SERVER
do
    # Create the directory for the server's reports
    mkdir -p $REPORT_DIR/$SERVER
    echo "Created directory: $REPORT_DIR/$SERVER"

    # Loop through the sar files in the /var/log/sa directory
    for FILE in $(ssh $SERVER "ls /var/log/sa/sa[0-9]*")
    do
        # Get the date from the file name
        DATE=$(basename $FILE | sed 's/sa//')

        # Run sar on the file and redirect the output to the report file
        ssh $SERVER "sar -u -f $FILE" > $REPORT_DIR/$SERVER/$DATE.cpuutilization.txt
        echo "Generated report: $REPORT_DIR/$SERVER/$DATE.cpuutilization.txt"
    done < $SERVERLIST

done < $SERVERLIST

