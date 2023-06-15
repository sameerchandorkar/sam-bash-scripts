#!/bin/bash

# SSH connection details
username="your_username"
server_ip="your_server_ip"

# SSH command to check server responsiveness
ssh_command="ssh $username@$server_ip"

# Check server responsiveness
check_responsiveness() {
    echo "Checking server responsiveness..."
    $ssh_command "date"
    $ssh_command "uptime"
    $ssh_command "ping -c 4 google.com"
}

# Check system logs
check_logs() {
    echo "Checking system logs..."
    $ssh_command "sudo tail -n 50 /var/log/messages"
    $ssh_command "sudo tail -n 50 /var/log/syslog"
    $ssh_command "sudo tail -n 50 /var/log/dmesg"
    $ssh_command "sudo tail -n 50 /var/log/auth.log"
    $ssh_command "sudo tail -n 50 /var/log/secure"
}

# Analyze system performance
analyze_performance() {
    echo "Analyzing system performance..."
    $ssh_command "top -n 1"
    $ssh_command "htop"
    $ssh_command "sar -u 1"
    $ssh_command "vmstat 1"
    $ssh_command "iostat -x 1"
}

# Main script
check_server_hangs() {
    check_responsiveness
    check_logs
    analyze_performance
}

# Execute the script
check_server_hangs

