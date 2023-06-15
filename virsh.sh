#!/bin/bash

# Function to display the menu
show_menu() {
    echo "========= VM Menu ========="
    echo "Choose an option:"
    echo "1. List VMs"
    echo "2. Start VM"
    echo "3. Shutdown VM"
    echo "4. Check VM Status"
    echo "5. Exit"
    echo "==========================="
}

# Function to list VM names from virsh list
list_vms() {
    echo "========= VM List ========="
    virsh list --all --name
    echo "==========================="
}

# Function to start a VM
start_vm() {
    echo "Enter the name of the VM to start:"
    read -r vm_name
    virsh start "$vm_name"
    echo "Starting VM: $vm_name"
}

# Function to shutdown a VM
shutdown_vm() {
    echo "Enter the name of the VM to shutdown:"
    read -r vm_name
    virsh shutdown "$vm_name"
    echo "Shutting down VM: $vm_name"
}

# Function to check the status of a VM
check_vm_status() {
    echo "========== Running all VMs =========="
    virsh list --state-running
    echo "=================================="
}

# Main script logic
while true; do
    show_menu
    read -r option

    case $option in
        1) list_vms ;;
        2) start_vm ;;
        3) shutdown_vm ;;
        4) check_vm_status ;;
        5) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    echo # Empty line for readability
done

