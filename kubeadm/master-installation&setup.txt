With AWS Acccount.
Create 3 or more Ubuntu Servers 
1 Master (4GB RAM , 2 Core) t2.medium
2 Workers (1 GB, 1 Core) t2.micro
Create Security Group and open required ports for kubernetes.

CONTROL PLANE PORTS & PROTOCOLS:			
Protocol: TCP, Direction: Inbound, Port Range: 6443, Purpose: Kubernetes API server, Used By All.
Protocol: TCP, Direction: Inbound, Port Range: 2379:2380, Purpose: etcd server client API, Used By: kube-apiserver, etcd.
Protocol: TCP, Direction: Inbound, Port Range: 10250, Purpose: Kubelet API, Used By: Self, Control plane.
Protocol: TCP, Direction: Inbound, Port Range: 10259, Purpose: kube-scheduler, Used By:	Self.

WORKER NODES PORTS & PROTOCOLS:
Protocol: TCP, Direction: Inbound, Port Range: 10250, Purpose: Kubelet API, Used By: Self, Control plane.
Protocol: TCP, Direction: Inbound, Port Range: 30000-32767, Purpose: NodePort Services†, Used By: All.

Create Security Group and open required ports for kubernetes.
Open all port for this illustration
Attach Security Group to EC2 Instance/nodes.

--------------------------------------------------

#1) SSH into the sever and Assign hostname & login as ‘root’ user because the following set of commands need to be executed with ‘sudo’ permissions.

sudo hostnamectl set-hostname master
sudo -i 

--------------------------------------------------

#!/bin/bash
# common.sh
# copy this script and run in all master and worker nodes

#2) Disable swap & add kernel settings

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


#3) Add  kernel settings & Enable IP tables(CNI Prerequisites)

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

#4) Install containerd run time

#To install containerd, first install its dependencies.

apt-get update -y
apt-get install ca-certificates curl gnupg lsb-release -y

#Note: We are not installing Docker Here.Since containerd.io package is part of docker apt repositories hence we added docker repository & it's key to download and install containerd.
# Add Docker’s official GPG key:
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Use follwing command to set up the repository:

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install containerd

apt-get update -y
apt-get install containerd.io -y

# Generate default configuration file for containerd

#Note: Containerd uses a configuration file located in /etc/containerd/config.toml for specifying daemon level options.
#The default configuration can be generated via below command.

containerd config default > /etc/containerd/config.toml

# Run following command to update configure cgroup as systemd for contianerd.

sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Restart and enable containerd service

systemctl restart containerd
systemctl enable containerd

#5) Installing kubeadm, kubelet and kubectl

# Update the apt package index and install packages needed to use the Kubernetes apt repository:

apt-get update
apt-get install -y apt-transport-https ca-certificates curl

# Download the Google Cloud public signing key:

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository:

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

apt-get update
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1

# apt-mark hold will prevent the package from being automatically upgraded or removed.

apt-mark hold kubelet kubeadm kubectl

# Enable and start kubelet service

systemctl daemon-reload
systemctl start kubelet
systemctl enable kubelet.service

------------------------------------------

# initialise the control plane
kubeadm init 

# Configure kubectl as a normal ubuntu user
sudo su - ubuntu

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# To verify, if kubectl is working or not, run the following command.
kubectl get pods -o wide -n kube-system

#You will notice from the previous command, that all the pods are running except one: ‘core-dns’. For resolving this we will install a # pod network addon like Calico or Weavenet ..etc. 
#Note: Install any one network addon don't install both. Install either weave net or calico.
#To install Weave network plugin/addon run the following command.

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
