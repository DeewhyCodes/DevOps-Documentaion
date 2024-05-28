- Ansible installation on ubuntu using apt repo

  sudo hostnamectl set-hostname ansible
  sudo adduser ansible
  echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
  sudo su - ansible
  sudo apt-add-repository ppa:ansible/ansible
  sudo apt install ansible -y
  sudo chown -R ansible:ansible /etc/ansible/

- Add the remote hosts to ansible inventory file

 k8s:

  #vi into /tmp/key.pem to create and add the key file for the host
   vi /tmp/key.pem
  #protect the key
   chmod 400 /tmp/key.pem
   sudo chown -R ansible:ansible /tmp/key.pem

  #vi into /etc/ansible/hosts to add the hosts
   [k8s]
   172.31.49.43 ansible_user=ubuntu ansible_ssh_private_key_file=/tmp/key.pem
   sudo vi /etc/ansible/hosts

  #for seamless automation, we could dissable host_key checking in ansible.cfg file
  #first copy the ansible.config file from the github link (https://github.com/ansible/ansible/blob/stable-2.9/examples/ansible.cfg), and paste
   sudo vi /etc/ansible/ansible.cfg

  #now test if ansible is able to communicate with k8s or all the hosts(if more than 1)
   ansible k8s -m ping
   ansible all -m ping
  
  #now we can start managing our k8s from ansible, try running commands
  ansible hosts -m modules -a "arguments" (ansible commands structure)
  ansible k8s -a "kubectl get pod"
  ansible k8s -a "kubectl get all" 
  ansible k8s -a "kubectl delete pod --all"
   


 
