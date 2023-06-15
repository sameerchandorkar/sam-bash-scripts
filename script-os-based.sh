#!/bin/bash

# Check the OS version
os_version=$(cat /etc/os-release | grep "VERSION_ID" | awk -F= '{print $2}' | tr -d '"')

# Perform actions based on OS version
if [[ "$os_version" == "7"* ]]; then
    # Actions for RHEL 7
    echo "Running script for RHEL 7..."
    # Add your RHEL 7 specific commands here
elif [[ "$os_version" == "8"* ]]; then
    # Actions for RHEL 8
    echo "Running script for RHEL 8..."
    # Add your RHEL 8 specific commands here
elif [[ "$os_version" == "9"* ]]; then
    # Actions for RHEL 9
    echo "Running script for RHEL 9..."
    # Add your RHEL 9 specific commands here
else
    # Unsupported OS version
    echo "Unsupported OS version: $os_version"
    exit 1
fi

