#!/bin/bash

# Create or clear the report file
report_file="python_version_report.csv"
echo "Server Name,Python Full Version" > "$report_file"

# Loop through the server list file
while IFS= read -r server; do
    echo "Processing server: $server"

    # Check the OS version
    os_version=$(ssh "$server" "lsb_release -r -s")

    # Check if OS is RHEL 6
    if [[ "$os_version" == "6."* ]]; then
        echo "Running script for RHEL 6 on $server..."

        # Find latest installed Python RPM version for RHEL 6
        python_version=$(ssh "$server" "rpm -qa --queryformat '%{VERSION}\n' python | sort -V | tail -n 1")

        # Append server name and Python version to the report file
        echo "$server,$python_version" >> "$report_file"
    else
        echo "Skipping server $server as it is not RHEL 6"
    fi
done < "srv"

