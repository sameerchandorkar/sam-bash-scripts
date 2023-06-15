#!/bin/bash

# Get the current date
current_date=$(date +%m-%d-%Y)

# Create the server_output directory
mkdir server_output

# Read the list of server names from the server file
server_file="server_list.txt"

# Read the list of folder name suffixes from the folder file
sox_file="sox_file.txt"

# Loop through each server in the server file
while read -r server_name; do
    # Loop through each folder name suffix in the folder file
    while read -r folder_name_suffix; do
        # Create the folder name by appending the server name, current date, and folder name suffix
        folder_name="${server_name}_${current_date}_${folder_name_suffix}"
        mkdir "server_output/$folder_name"

        # Read the list of files to copy from the file list
        file_list="file_list.txt"

        # Loop through each file in the file list
        while read -r file; do
            # Copy the file from the remote server to the folder
            scp "$server_name:$file" "server_output/$folder_name" >> /dev/null
        done < "$file_list"

        # Rename files in the created folder and add the header
        cd "server_output/$folder_name"
        header="US RESTRICTED DATA - ${server_name} - ${current_date}\n"
        for file in *; do
            mv "$file" "${server_name}_${file}"
            echo -e "$header$(cat "${server_name}_${file}")" > "${server_name}_${file}"
        done
        cd ../..
    done < "$sox_file"
done < "$server_file"

