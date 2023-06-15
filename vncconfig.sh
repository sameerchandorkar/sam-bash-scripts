#!/bin/bash
#Check Tigervnc server version, if less than 1.10.1, please update Tigervnc packages to the latest version
begin_version=1.10.1
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
current_tigervnc_server_version=`rpm -qa | grep "tigervnc-server-[0-9]\+.[0-9]\+.[0-9]\+" | awk -F- '{print $3}'`
if [ ! $current_tigervnc_server_version ]; then
   echo "Tigervnc sever not found, please install and try again."
   exit -1
fi
if version_lt $current_tigervnc_server_version $begin_version; then
   echo "TigerVNC sever $current_tigervnc_server_version less than 1.10.1."
   echo "Please update Tigervnc packages to the latest version."
   exit -1
fi

# Clean any existing files in /tmp/.X11-unix environment except X0
find /tmp/.X11-unix/ -name "X[1-9]*" | xargs rm -f

# Stop all running vncserver before:
systemctl stop vncserver@* > /dev/null 2>&1

userNum=1
# Step 1: Find the available port(s) for VNC service
port=5901
session=1
count=0
ports=()
sessions=()
currentTimestamp=`date +%y-%m-%d-%H:%M:%S`
while [ "$count" -lt "$userNum" ]; do
    netstat -a | grep ":$port\s" >> /dev/null
    if [ $? -ne 0 ]; then
        ports[$count]=$port
        sessions[$count]=$session
        count=`expr $count + 1`
        echo $port" is available for VNC service"
    fi
    session=`expr $session + 1`
    port=`expr $port + 1`
done

# Step 2: Set the VNC password
echo "Please set the VNC password for user sameer"
su - sameer -c vncpasswd

# Step 3: Write the VNC configuration
# Backup the existing configuration file
vnc_conf="/etc/systemd/system/vncserver@:"${sessions[0]}".service"
vnc_conf_backup=$vnc_conf.vncconfig.$currentTimestamp
if [ -f "$vnc_conf" ]; then
    echo backup $vnc_conf to $vnc_conf_backup
    mv $vnc_conf $vnc_conf_backup
fi

# Add a user mapping in /etc/tigervnc/vncserver.users
vnc_user_mapping="/etc/tigervnc/vncserver.users"
vnc_user_mapping_backup=$vnc_user_mapping.$currentTimestamp
if [ -f "$vnc_user_mapping" ]; then
    echo backup $vnc_user_mapping to $vnc_user_mapping_backup
    cp $vnc_user_mapping $vnc_user_mapping_backup
fi
echo "
:1=sameer
" > /etc/tigervnc/vncserver.users

# Configure Xvnc options
vnc_config_default="/etc/tigervnc/vncserver-config-defaults"
vnc_config_default_backup=$vnc_config_default.$currentTimestamp
if [ -f "$vnc_config_default" ]; then
    echo backup $vnc_config_default to $vnc_config_default_backup
    cp $vnc_config_default $vnc_config_default_backup
fi
echo "
session=gnome
" > /etc/tigervnc/vncserver-config-defaults

# Create specific config for each user in /home/<user>/.vnc
vnc_user_config="/home/sameer/.vnc/config"
vnc_user_config_backup=$vnc_user_config.$currentTimestamp
if [ -f "$vnc_user_config" ]; then
    echo backup $vnc_user_config to $vnc_user_config_backup
    cp $vnc_user_config  $vnc_user_config_backup
fi
touch /home/sameer/.vnc/config
chmod 766 /home/sameer/.vnc/config
echo "
geometry=1920x1080
" > /home/sameer/.vnc/config
restorecon -rv /home/sameer/.vnc


# Step 4: Start the VNC service
# Start the VNC service
systemctl daemon-reload
systemctl enable vncserver@:${sessions[0]}.service
systemctl start vncserver@:${sessions[0]}.service

# Step 5: If default firewall is used, we will open the VNC ports

# Step 6: Echo the information that VNC client can connect to
red='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${red}Display number for user sameer is ${sessions[0]}${NC}"
