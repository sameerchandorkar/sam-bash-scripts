#!/bin/bash

# Output file name
output_file="report.csv"

# Remove the output file if it already exists
rm -f "$output_file"

# Iterate over the servers from the server.txt file
while IFS= read -r server; do
  echo "Processing $server..."

  # SSH command to retrieve file permissions and last modified dates
  ssh_output=$(ssh "$server" 'find /path/to/files -type f -printf "%p,%M,%t\n"')

  # Iterate over the output and append to the report file
  while IFS= read -r line; do
    filename=$(echo "$line" | cut -d ',' -f 1)
    permission=$(echo "$line" | cut -d ',' -f 2)
    modified_date=$(echo "$line" | cut -d ',' -f 3)

    # Convert permission to rwx format
    permission_rwx=$(echo "$permission" | sed -e 's/./& /g' | awk '{
      if ($1 == "-") $1 = "r"; else $1 = "-";
      if ($2 == "-") $2 = "w"; else $2 = "-";
      if ($3 == "-") $3 = "x"; else $3 = "-";
      print $1$2$3
    }')

    # Convert modified date to date and time format
    modified_date_formatted=$(date -d "@$modified_date" "+%Y-%m-%d %H:%M:%S")

    echo "$server,$filename,$permission_rwx,$modified_date_formatted" >> "$output_file"
  done <<< "$ssh_output"

  echo "Finished processing $server."
done < "server.txt"

echo "Report generated successfully in $output_file."

