# Kubernetes Operations (kops)

Kubernetes Operations is an open-source project that provides a production-grade toolset for deploying, managing, and maintaining Kubernetes clusters. It's particularly well-suited for managing clusters on cloud providers like AWS, Google Cloud, and DigitalOcean, but can also work with on-premises infrastructure.

## Steps to set-up and deploy a production-ready application using kops

- **Create an ubuntu ec2 instance in aws**
- **create kops user and grant sudo access**

```sh
sudo adduser kops
sudo echo "kops ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kops
sudo su - kops
```

- **install awscli using the apt package manager**

```sh
sudo apt update
sudo apt install awscli -y

#OR from the linux official documentation

sudo apt update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

([awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))

- **Install kubectl kubernetes client if it is not already installed**

```sh
 sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
 sudo chmod +x ./kubectl
 sudo mv ./kubectl /usr/local/bin/kubectl
```

- **Install kops software**

```sh
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
sudo chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
```

- **create an IAM role on aws console and attach it to the master server**

```sh
AmazonEC2FullAccess
AmazonS3FullAccess
AmazonSQSFullAccess
AmazonEventBridgeFullAccess
IAMFullAccess
AmazonVPCFullAccess
```

- **create a s3 bucket or use an existing bucket**

```sh
aws s3 mb s3://testkops
aws s3 ls # to verify

#Expose environmental variable

Expose environment variable:
# Add env variables in bashrc

vi .bashrc
  # Give Unique Name And S3 Bucket which you created.
  export NAME=test.k8s.local #k8s cluster
  export KOPS_STATE_STORE=s3://testkops
source .bashrc
```

- **create sshkey before creating cluster**

```sh
ssh-keygen -t rsa -b 4096
```

- **Create kubernetes cluster definitions on S3 bucket**

```sh
kops create cluster --zones us-east-1a --networking weave --master-size t2.medium --master-count 1 --node-size t2.medium --node-count=2 ${NAME}
# copy the sshkey into your cluster to be able to access your kubernetes node from the kops server
kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
```

- **Initialise your kops kubernetes cluser by running the command below**

```sh
kops update cluster --name ${NAME} --yes
```

- **Validate your cluster(KOPS will take some time to create cluster ,Execute below commond after 3 or 4 mins)**

```sh
kops validate cluster
kops get cluster
kops edit cluster test.k8s.local #to edit cluster
```

- **Export the kubeconfig file to manage your kubernetes cluster from a remote server. For this demo, Our remote server shall be our kops server**

```sh
 kops export kubecfg $NAME --admin
```

- **To list nodes and pod to ensure that you can make calls to the kubernetes apiSAerver and run workloads**

```sh
  kubectl get nodes
```

- **Alternatively you can ssh into your kubernetes master server using the command below and manage your cluster from the master**

```sh
sh -i ~/.ssh/id_rsa ubuntu@ipAddress
ssh -i ~/.ssh/id_rsa ubuntu@18.222.139.125
ssh -i ~/.ssh/id_rsa ubuntu@172.20.58.124
```

- **Alternative, Enable PasswordAuthentication in the master server and assign passwd**

```sh
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
sudo passwd ubuntu
```

- **To delete cluster**

```sh
kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE} --yes
```

- **IF you want to SSH to Kubernetes Master or Nodes Created by KOPS. You can SSH From KOPS_Server**

```sh
sh -i ~/.ssh/id_rsa ubuntu@ipAddress ssh -i ~/.ssh/id_rsa ubuntu@3.90.203.23
```

- NB: whenever you stop a server created by kops, it will be terminated and a new server will be recreated. then you have to run the export command again to pass the credentials

```sh
 kops export kubecfg $NAME --admin
```
