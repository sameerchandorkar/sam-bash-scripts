#!/bin/bash

# Define password policy parameters
min_length=15
min_complexity=4
min_diff_chars=15
max_repeats=3
retry_times=3

# Backup the original system-auth file
sudo cp /etc/pam.d/system-auth /etc/pam.d/system-auth.backup

# Update the password policy in system-auth file
sudo sed -i '/password\s*requisite\s*pam_pwquality.so/c password    requisite     pam_pwquality.so try_first_pass local_users_only retry=${retry_times} authtok_type= minlen=${min_length} dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 minclass=${min_complexity} difok=${min_diff_chars} maxrepeat=${max_repeats} enforce_for_root' /etc/pam.d/system-auth

echo "Password policy enforced successfully."

