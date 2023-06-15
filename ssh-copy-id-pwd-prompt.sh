#!/bin/bash

# prompt the user for the password
read -s -p "Enter password: " password

# loop over the server IPs
for i in 254 100 200 ; do

  # execute the ssh-copy-id command using expect
  expect << EOF
    spawn ssh-copy-id root@192.168.122.$i
    expect "password:" { send "$password\r" }
    expect eof
EOF

done

