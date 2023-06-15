#!/bin/bash

# Create a report file
report_file="rhel6_policy_report.txt"
rm -f "$report_file"

# Read server list from srv.txt
while IFS= read -r server; do
    # Check the OS version
    os_version=$(ssh "$server" 'cat /etc/redhat-release' | grep -oE '[0-9]+\.[0-9]+')

    # Perform actions based on OS version
    if [[ "$os_version" == "6"* ]]; then
        # Check if password policy entries are present
        entries_present=$(ssh "$server" 'grep -q "^password.*requisite.*pam_cracklib.so minlen=15 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 retry=3" /etc/pam.d/system-auth-ac && echo "yes" || echo "no"')

        if [[ "$entries_present" == "yes" ]]; then
            echo "Server: $server" >> "$report_file"
            echo "Password Policy: minlen=15 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 retry=3" >> "$report_file"
            echo >> "$report_file"
        else
            echo "Server: $server" >> "$report_file"
            echo "Password Policy: Not implemented" >> "$report_file"
            echo >> "$report_file"
        fi
    else
        echo "Unsupported OS version on $server: $os_version" >> "$report_file"
        echo >> "$report_file"
    fi
done < srv

echo "Report generated successfully. Check $report_file for details."
