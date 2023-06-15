#!/bin/bash

# Output file name
output_file="password-policy-report.csv"

# Clear the output file
> "$output_file"

# Read server names from the server.txt file
while IFS= read -r server; do
  # SSH into the server and retrieve the OS version
  os_version=$(ssh "root@$server" "cat /etc/os-release | grep 'VERSION_ID' | awk -F= '{print \$2}' | tr -d '\"'")

  # Perform actions based on OS version
  if [[ "$os_version" == "7"* ]]; then
    # Actions for RHEL 7
    policy=$(ssh "root@$server" "sudo grep -E '^[\t ]*[^#\t ]+[\t ]+' /etc/security/pwquality.conf")
  elif [[ "$os_version" == "8"* ]]; then
    # Actions for RHEL 8
    policy=$(ssh "root@$server" "sudo grep -E '^[\t ]*[^#\t ]+[\t ]+' /etc/security/pwquality.conf")
  else
    # Unsupported OS version
    echo "Unsupported OS version on server: $server"
    continue
  fi

  # Extract the policy value
  policy_value=$(echo "$policy" | awk -F' ' '{print $NF}')

  # Append the server name and policy to the output file
  echo "$server, $policy_value" >> "$output_file"

done < serverlist.txt

