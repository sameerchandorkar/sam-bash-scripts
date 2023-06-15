#!/bin/bash
echo -e "\e[1;36m####################################################################################\e[0m"
echo -e "\e[1;36mPlease wait till all instanaces are stopped and deleted ...........................\e[0m"
echo -e "\e[1;36m####################################################################################\e[0m"
for i in master worker1 worker2 ; do virsh destroy $i ; echo $i shutdown ; done &> /dev/null
sleep 5 
for i in master worker1 worker2 ; do virsh undefine $i --remove-all-storage ; echo $i deleted ; done 
echo -e "\e[1;36m...................................................................................\e[0m"
echo -e "\e[1;36m####################All instances removed successfully####################\e[0m"
echo -e "\e[1;36m...................................................................................\e[0m"
