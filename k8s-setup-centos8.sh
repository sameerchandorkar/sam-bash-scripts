#!/bin/bash

# Step 1: Edit the hosts file
cat <<EOF >> /etc/hosts
192.168.122.254 master.example.com master 
192.168.122.100 worker1.example.com worker1 
192.168.122.200 worker2.example.com worker2
EOF

# Step 2: Install Docker-CE on CentOS 8
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y --allowerasing
systemctl enable --now docker
#systemctl status docker
usermod -aG docker $USER

# Step 3: Update kubernetes repo and installation 
cat <<EOF >> /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Step 4: Install kubelet, kubeadm, and kubectl
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Step 5: Add KUBELET_EXTRA_ARGS to the kubelet config
cat <<EOF >> /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS= --runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice
EOF

# Step 6: Enable and start the kubelet service
systemctl enable --now kubelet
#systemctl status kubelet

# Step 7: Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Step 8: Configure Docker to use systemd as the cgroup driver

echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json


#cat <<EOF >> /etc/docker/daemon.json
#{
#    "exec-opts": ["native.cgroupdriver=systemd"],
#    "log-driver": "json-file",
#    "log-opts": {
#      "max-size": "100m"
#    },
#    "storage-driver": "overlay2",
#    "storage-opts": [
#      "overlay2.override_kernel_check=true"
#    ]
#  }
#EOF

# Step 9: Create a directory for Docker service configuration
mkdir -p /etc/systemd/system/docker.service.d

# Step 10: Reload the systemd daemon and restart Docker
systemctl daemon-reload
systemctl restart docker
#systemctl status docker

# Step 11: Configure containerd to use systemd as the cgroup driver
cat > /etc/containerd/config.toml <<EOF
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
EOF
systemctl enable --now containerd
systemctl restart containerd
#systemctl status containerd

# Step 12: Initialize the Kubernetes cluster
kubeadm init

sleep 5
#To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Step 13: Add a pod network add-on
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
sleep 10

#TO verify cluster health 
watch kubectl get nodes 
