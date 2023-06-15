#!/bin/bash

# Read server list from srv.txt
while IFS= read -r server; do
    # Check the OS version
    os_version=$(ssh "$server" 'cat /etc/redhat-release' | grep -oE '[0-9]+\.[0-9]+')

    # Perform actions based on OS version
    if [[ "$os_version" == "6"* ]]; then
        # Check if pam_passwdqc package is already installed
        package_installed=$(ssh "$server" 'rpm -q pam_passwdqc')

        if [[ -z "$package_installed" ]]; then
            # Install pam_passwdqc package
            ssh "$server" 'yum install -y pam_passwdqc'
        else
            echo "pam_passwdqc package is already installed on $server"
        fi

        # Check if password policy entries are already present
        entries_present=$(ssh "$server" 'grep -q "^password.*requisite.*pam_cracklib.so minlen=15 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 retry=3" /etc/pam.d/system-auth-ac && echo "yes" || echo "no"')

        if [[ "$entries_present" == "no" ]]; then
            # Add password policy entries in /etc/pam.d/system-auth-ac
            ssh "$server" "sed -i -r '/^password.*requisite.*pam_cracklib.so/s/.*/password    requisite    pam_cracklib.so minlen=15 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 retry=3/' /etc/pam.d/system-auth-ac"
        else
            echo "Password policy entries already present in /etc/pam.d/system-auth-ac on $server"
        fi
    else
        echo "Unsupported OS version on $server: $os_version"
    fi
done < srv

