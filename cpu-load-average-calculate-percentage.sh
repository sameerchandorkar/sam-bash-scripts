#!/usr/bin/bash

# Get the number of CPU cores
num_cores=$(grep -c '^processor' /proc/cpuinfo)

# Get the load average for the past 1 minute
load_avg=$(uptime | awk -F'[a-z]:' '{ print $2 }' | awk -F', ' '{ print $1 }')

# Calculate the load average percentage
load_avg_percentage=$(echo "scale=2; 100 * $load_avg / $num_cores" | bc)

# Print the result
echo "CPU Load Average: $load_avg_percentage%"

