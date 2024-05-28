Ansible playbooks: are YAML files that define a set of tasks to be executed on a group of hosts. 
 Playbooks are used to orchestrate IT processes, manage configurations, deploy applications, 
 and automate tasks. They are a key part of Ansible's automation capabilities.

 Structure of an Ansible Playbook
 An Ansible playbook typically consists of one or more plays, each of which can include tasks, variables, handlers, and more. Here’s a breakdown of the main components:

 - Hosts: Defines target host or group of hosts
 - Tasks: A list of tasks to be executed.
 - Variables: Values that can be used and referenced within the playbook.
 - Handlers: Tasks that are triggered by other tasks.
 - Roles: A way to organize playbooks into reusable components.

 Basic Example of an Ansible Playbook: 

----------------------------------------------------------------------------------------------------
#Ticket01) #Playbook to copy a kubernetes manifest file from ansible, and deploy it in kubernetes
  - hosts: all
    tasks:
      - name: test connection
        ping:
        remote_user: ubuntu
  - hosts: k8s
    tasks:
      - name: create dev namespace
        kubernetes.core.k8s:
          name: dev
          api_version: v1
          kind: Namespace
          state: present
      - name: copy kubernetes manifest file
        copy: src=app.yml dest=/tmp/app.yml
      - name: deploy application
        shell: kubectl apply -f /tmp/app.yml
  
  ansible-playbook ns.yml --syntax-check 
  ansible-playbook ns.yml --check 
  ansible-playbook ns.yml

-------------------------------------------------------------------------------------------------------------
#Ticket02) Ansible playbook to deploy an index.html file in an apache webserver
  index.html
  ===========
  <!DOCTYPE html>
  <html>
  <head>
      <title>Welcome</title>
  </head>
  <body>
      <h1>Welcome to My Web Server</h1>
      <p>This is a simple web page served by Apache.</p>
  </body>
  </html>
  
  apache.yml
  =========
  #we could also use this syntax structure
  ---
  - hosts: web #This specifies the target hosts group 'web' and uses privilege escalation with 'become: true'.
    become: true
    tasks:
      - name: Install Apache #Installs the Apache web server using the yum package manager.
        yum:
          name: httpd
          state: present
      - name: Start Apache #Starts the Apache service and ensures it is enabled to start on boot using the systemd module.
        systemd:
          name: httpd
          state: started
          enabled: true
      - name: Copy the index.html file #Copies the index.html file to the Apache document root and notifies the handler to restart Apache if the file is updated.
        copy:
          src: index.html
          dest: /var/www/html/index.html
        notify:
          - Restart Apache
    handlers:
      - name: Restart Apache #Defines a handler to restart Apache using the systemd module. This handler is triggered by the copy task if the file changes.
        systemd:
          name: httpd
          state: restarted
  
-----------------------------------------------------------------------------------------------------------------
#Ticket03) Create ansible user in all hosts    
  create_user.yml   
  ===============
  # ansible <group/host Name> -m ping -u <userName> --private-key=~/devops.pem
  # ansible-playbook -b ansible-createuser.yml -u <userName> --private-key=~/devops.pem
  ---
  - hosts: all
    become: true
    tasks:
      - name: Create Ansible User
        user:
          name: ansible
          create_home: true
          shell: /bin/bash
          comment: "Ansible Management Account"
          expires: -1
          password: "{{ 'DevOps@2020' | password_hash('sha512', 'A512') }}"
  
      - name: Deploy Local User SSH Key
        authorized_key:
          user: ansible
          state: present
          manage_dir: true
          key: "{{ lookup('file', '/home/ansible/.ssh/id_ed25519.pub') }}"
  
      - name: Setup Sudo Access for Ansible User
        copy:
          dest: /etc/sudoers.d/ansible
          content: 'ansible ALL=(ALL) NOPASSWD: ALL'
          validate: /usr/sbin/visudo -cf %s
  
      - name: Disable Password Authentication
        lineinfile:
          dest: /etc/ssh/sshd_config
          regexp: '^PasswordAuthentication'
          line: 'PasswordAuthentication no'
          state: present
          backup: yes
        notify:
          - restart ssh
  
    handlers:
      - name: restart ssh
        service:
          name: ssh
          state: restarted
  
#Ticket04) playbooks with loops and conditions
  loops.yml 
  - hosts: localhost  
    become: true
    gather_facts: false  
    tasks:
     - name: Install packages
       package:
         name: ['nano', 'wget', 'vim', 'zip', 'unzip', 'tree']
         state: latest  
       when: ("ansible_distribution" == "Ubuntu")
  ---
  loop2.yml   
  - hosts: localhost
    become: true
    tasks:
      - name: Install list of packages
        become: true  
        apt: name='{{item}}' state=present
        loop: #( use 'loop' beacuse 'with_item' is deprecated)
         - nano
         - wget
         - vim
         - zip
         - unzip  

#Ticket05) ansible variables in playbooks

  - hosts: localhost
    vars:
      name: From Playbook
    tasks:
    - name:  demo vars
      debug:
        msg: "{{name}}"
  
  
  ---
  - hosts: localhost
    vars:
      name: From Playbook
      password: dev@123
    tasks:
    - name:  demo vars
      debug:
        msg: "{{name}}"
    - name: vars demo2
      debug:
        msg: "{{password}}"
  ansible-playbook vars.yml --extra-vars name=runtime
  ansible-playbook vars.yml --extra-vars name="runtime"
  
  
  vars2.yml  
   - hosts: localhost 
     vars:
       mypassword: dev@123
     gather_facts: false      
     tasks:
     - name: your password    
       debug:
         msg: "{{ mypassword }}"
   #its not a good practice to pass sensitive information directly in the playbook
   
  vars2.yml  
   - hosts: web 
     gather_facts: false      
     tasks:
     - name: your password    
       debug:
         msg: "{{ mypassword }}"
   ansible-playbook vars2.yml --extra-vars mypassword=admin@abc
   #we can pass the variable during run time
   
   #also we could create a group_var director in ansible, then we can create our variable files in the directory
    ls -l /etc/ansible/
    chown ansible:ansible /etc/ansible/
    mkdir /etc/ansible/group_vars/
    touch /etc/ansible/group_vars/all.yml  #'all.yml' represents all the hosts
     mypassword: admin123 #this will overwrite the playbook variables
    touch /etc/ansible/group_vars/web.yml #web.yml represents the specified host
     mypassword: admin123 #this will overwrite the playbook variables and all.yml variable file because 'web' host  is specified
    RUN: ansible-playbook vars2.yml 
    Variable strengths:
    1. runtime variables    = 1st  place  
    2. playbook variables   = 2nd  place
    3. host_vars variables  = 3rd place
    4. group_vars variables = 4th place  
  
  ANSIBLE VAULT.:
   
    secrets variables like passwords, sshKeys, certs
    are treated in ansible by using ansible vault.
    
    hashicorp VAULT.:
    It is use to create and store secrets in hashicorp.
    
    ansible-vault
    ===============
    stores and encrypt confidential or secrets  data.
     [password / sshkeys / tokens / certificates ]   
    
    ansible-vault create  /etc/ansible/group_vars/all.yml 
    ansible-vault encrypt /etc/ansible/group_vars/all.yml
    ansible-vault encrypt /etc/ansible/group_vars/web.yml 
    
    ansible-vault decrypt /etc/ansible/group_vars/all.yml
    ansible-vault view /etc/ansible/group_vars/all.yml
    ansible-vault edit /etc/ansible/group_vars/all.yml
    ansible-vault rekey /etc/ansible/group_vars/all.yml
    ansible-vault create  /etc/ansible/group_vars/all.yml 
    
    ansible-playbook vars2.yml --ask-vault-pass
    ansible k8s -m ping --ask-vault-pass  
    run using a vault password file:
       ansible k8s -m ping --vault-password=vaultpass
       ansible-playbook vars2.yml --vault-password=vaultpass
    
    ansible-vault decrypt /etc/ansible/group_vars/all.yml --vault-password=vaultpass
    
    How can specific tasks be runned in a playbooks?
1. ansible-playbook apache.yml  --step
2. assign tags to tasks 

ansible-playbook pb.yml  --skip-tags 'install,start'
ansible-playbook pb.yml --tags 'install'
ansible-playbook pb.yml --tags 'copy'

ansible-playbook apache.yml  --syntax-check
what is dry run in ansible?
ansible-playbook apache.yml  --check  =# dry run
ansible-playbook apache.yml  --step
ansible-playbook apache.yml  --list-hosts


What is verbose mode in ansible? -v -vv -vvv
ansible-playbook apache.yml -v 
ansible k8s -a "kubectl get ns" -v=7 
kubectl create ns dev -v=7 