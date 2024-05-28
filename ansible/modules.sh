Ansible modules: Ansible modules are the building blocks for Ansible tasks, 
enabling users to automate various aspects of IT infrastructure. They are small, 
reusable scripts that perform specific functions, such as installing software, managing files,
or configuring services. They are written python scripts that can be invoked in playbooks

#to list all ansible modules
ansible-doc -l
#to list all docker-related modules
ansible-doc -l | grep docker
#to list all docker-container-related modules
ansible-doc community.docker.docker_container


**Ansible default modules**
command
shell
ping
yum
apt
package

   ansible localhost -m package -a "name=vim state=latest"
   ansible localhost -m apt -a "name=vim state=present" -b    
    ping / :
       ansible all -m ping
    command / :
       ansible all -m command -a "ping"
       ansible all -m shell -a "ping"
       ansible all -m commad -a "df -h"
       ansible all  -a "df -h"
       ansible docker -m command -a "apt install docker.io"
       ansible docker -a "apt install docker.io"
    shell / :
       ansible all -m shell -a "ping"
       ansible docker -m shell -a "apt install docker.io"
    service/systemd / systemctl / :
       ansible db -m service -a "name=sshd state=restarted"
       ansible db -m systemd -a "name=httpd state=started" 

  ansible-doc -l
  https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html


#some ansible hardcore commands examples
ansible appservers -m command -a "df -h"
ansible appservers -m shell -a "free -m"
ansible appservers -m yum -a "name=httpd state=present" -b
ansible appservers -m apt -a "name=httpd state=present" -b
ansible appservers -m package -a "name=httpd state=present" -b 
ansible k8s -m command -a "kubectl get pod"
ansible k8s -a "kubectl get pod"
ansible k8s -m copy -a "src=index.html dest=/var/www/html/index.html"
ansible k8s -m copy -a "src=app.yml dest=/tmp/app.yml"
ansible k8s -a "kubectl apply -f /tmp/app.yml"

#to list kubernetes-related modules
ansible-doc kubernetes.core.k8s

