echo -e "\e[1;36m###############################################################################\e[0m"
echo -e "\e[1;36mWait till all instances are clone .................. \e[0m"
echo -e "\e[1;36m###############################################################################\e[0m"
virt-clone --connect=qemu:///system -o master-config-centos8 -n master --auto-clone -f /var/lib/libvirt/images/master.qcow2 
virt-clone --connect=qemu:///system -o worker1-config-centos8 -n worker1 --auto-clone -f /var/lib/libvirt/images/worker1.qcow2
virt-clone --connect=qemu:///system -o worker2-config-centos8 -n worker2 --auto-clone -f /var/lib/libvirt/images/worker2.qcow2
for i in master worker1 worker2 ; do virsh start $i ; done
echo -e "\e[1;36m###############################################################################\e[0m"
echo -e "\e[1;36m wait till all instances are up ......................... \e[0m"
echo -e "\e[1;36m###############################################################################\e[0m"
sleep 20
for i in 254 100 200 ; do echo test | ncat -v -t 192.168.122.$i 22 | grep Connected | grep -v nmap ; done
echo -e "\e[1;36m###############################################\e[0m"
virsh list 
echo -e "\e[1;36m###############################################################################\e[0m"
echo -e "\e[1;36m ........................Enjoy your kubernetes lab........................ \e[0m"
echo -e "\e[1;36m###############################################################################\e[0m"
