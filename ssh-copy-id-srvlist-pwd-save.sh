#!/bin/bash

# read the server IPs and passwords from the file
while IFS=: read -r ip password; do

  # execute the ssh-copy-id command using expect
  expect << EOF
    spawn ssh-copy-id root@$ip
    expect "password:" { send "$password\r" }
    expect eof
EOF

done < server_passwords.txt

