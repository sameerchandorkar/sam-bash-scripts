#!/bin/bash

# Generate a new password
NEW_PASSWORD=$(pwgen -s 12 1)

# Change the root password
echo "Changing root password..."
echo "ahmed:$NEW_PASSWORD" | chpasswd

# Display the new password
echo "New root password: $NEW_PASSWORD"
