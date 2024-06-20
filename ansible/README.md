# **Ansible**

Ansible is an open-source automation tool used for IT tasks such as configuration management, application deployment, and task automation. It is designed to be simple, powerful, and agentless, meaning it does not require any software to be installed on the target machines it manages. Here are some key features and benefits of Ansible:

**Agentless Architecture:**
Ansible uses SSH to connect to the target machines, so no additional software or agents need to be installed on those machines.

**Playbooks:**
Ansible uses YAML (Yet Another Markup Language) for its playbooks, which are easy-to-read scripts that define the tasks to be executed on the managed hosts.

**Idempotency:**
Ansible ensures that applying the same playbook multiple times will result in the same state, making it safe to run repeatedly without causing unintended changes.

**Modules:**
Ansible includes a wide range of modules that perform various tasks, such as managing packages, services, files, and more. Users can also write custom modules.

**Inventory:**
Ansible uses an inventory file to list the hosts and groups of hosts to manage. This can be a simple static file or dynamically generated.

**Extensible and Flexible:**
Ansible can be extended with custom modules, plugins, and roles to fit specific needs and integrate with various systems and applications.

**_Tasks to run on Servers/hosts:_**

- UsersMGT
- FilesMGT
- ServicesMGT
- PackagesMGT
- Deployments, Managements, Build, Tests and Congigure apps.

**Conclusion**
Ansible is a versatile and powerful automation tool that simplifies IT operations and DevOps practices. Its ease of use, agentless architecture, and robust feature set make it a popular choice for automating repetitive tasks, managing complex environments, and ensuring consistent configurations across systems.

---

# Installation & set-up

**Task:** provision an ec2-instance in aws called ansible using ubuntu ami (with terraform), install and setup ansible

1. Provision instance

```terraform
provider "aws" {

}

resource "aws_instance" "ansible" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.micro"
  subnet_id       = "subnet-030c60b43b59dfed7"
  key_name        = "terraformKey"
  security_groups = ["sg-0c0e098bcffb41933"]
  tags = {
    Name = "ansible"
  }
}
```

2. Ansible installation on ubuntu using apt repo

```/bin/sh
sudo hostnamectl set-hostname ansible
sudo adduser ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
sudo su - ansible
sudo apt update
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible -y
sudo chown -R ansible:ansible /etc/ansible/
```

**Add the remote hosts to ansible inventory file**

- k8s:

  ```sh
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
  #first copy the ansible.config file from the github link, and paste
   sudo vi /etc/ansible/ansible.cfg

  #now test if ansible is able to communicate with k8s or all the hosts(if more than 1)
   ansible k8s -m ping
   ansible all -m ping
  ```

  Link to ansible.config ([ansible.config](https://github.com/ansible/ansible/blob/stable-2.9/examples/ansible.cfg))

---

# Ansible modules

**Ansible modules:** Ansible modules are the building blocks for Ansible tasks, enabling users to automate various aspects of IT infrastructure. They are small, reusable scripts that perform specific functions, such as installing software, managing files, or configuring services. They are written python scripts that can be invoked in playbooks

**Ansible default modules**
command
shell
ping
yum
apt
package

**Some categories of ansible modules**

- Packaging Modules:

  ```yaml
  #apt: Manages packages on Debian-based systems
  - name: Install NGINX
  apt:
    name: nginx
    state: present

  #yum: Manages packages on RedHat-based systems
  - name: Install NGINX
  yum:
    name: nginx
    state: present
  ```

- Service Modules:

  ```yaml
  #service: Manages services
  - name: Ensure NGINX is running
  service:
    name: nginx
    state: started

  #systemd: Manages systemd services
  - name: Ensure NGINX is running
  systemd:
    name: nginx
    state: started
  ```

- File Modules:

  ```yaml
  #copy: Copies files to remote locations
  - name: Copy configuration file
  copy:
    src: ./nginx.conf
    dest: /etc/nginx/nginx.conf

  #file: Manages file properties
  - name: Ensure a directory exists
  file:
    path: /etc/nginx/sites-available
    state: directory
    mode: '0755'
  ```

- Cloud Modules:

  ```yaml
  #ec2:Manages ec2 instances on aws.
  - name: Launch an EC2 instance
  ec2:
    key_name: mykey
    instance_type: t2.micro
    image: ami-0c55b159cbfafe1f0
    wait: yes

  #gcp_compute_instance: Manages instances on Google Cloud Platform
  - name: Launch a GCP instance
  gcp_compute_instance:
    name: my-instance
    machine_type: n1-standard-1
    image: projects/debian-cloud/global/images/family/debian-10
  ```

---

# Ansible playbooks

**Ansible playbooks:** are YAML files that define a set of tasks to be executed on a group of hosts. Playbooks are used to orchestrate IT processes, manage configurations, deploy applications, and automate tasks. They are a key part of Ansible's automation capabilities.

**Structure of an Ansible Playbook**
An Ansible playbook typically consists of one or more plays, each of which can include tasks, variables, handlers, and more. Here’s a breakdown of the main components:

- **Hosts:** Defines target host or group of hosts
- **Tasks:** A list of tasks to be executed.
- **Variables:** Values that can be used and referenced within the playbook.
- **Handlers:** Tasks that are triggered by other tasks.
- **Roles:** A way to organize playbooks into reusable components.

**Basic Example of an Ansible Playbook:**

```yaml
#Playbook to copy a kubernetes manifest file from ansible, and deploy it in kubernetes
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
```

**Loops and Conditions**

```yaml
#my distributions: web [ubuntu / Redhat / windows / CentOS]
loops.yml
- name: Install packages
  hosts: all
  tasks:
    - name: Install packages
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - package1
        - package2
        - package3

    - name: Install additional package only on CentOS
      yum:
        name: additional_package
        state: present
      when: ansible_distribution == 'CentOS'
---
web [ ubuntu / Redhat / windows ]
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
```

```sh
ansible-playbook ns.yml --syntax-check #to check the syntax
ansible-playbook ns.yml --check #to dry run
ansible-playbook ns.yml #to run the playbook
```

---

# Ansible variables

Variables in Ansible playbooks allow you to define and use dynamic values that can be reused across tasks and roles. They provide flexibility and make your playbooks more configurable. Here's how you can work with variables in Ansible:

**Variables**

- runtime variables
- playbook variables
- host_var variables
- group_vars variables

```yaml
- name: Example task with inline variables
  debug:
    msg: "My variable is {{ my_variable }}"
  vars:
    my_variable: "Hello, world!"

---
- name: Example playbook with defined variables
  hosts: localhost
  vars:
    my_variable: "Hello, world!"
  tasks:
    - name: Example task using defined variable
      debug:
        msg: "My variable is {{ my_variable }}"
---
- hosts: localhost
  vars:
    name: From Playbook
  tasks:
    - name: demo vars
      debug:
        msg: "{{name}}"

---
- hosts: localhost
  vars:
    name: From Playbook
    password: dev@123
  tasks:
    - name: demo vars
      debug:
        msg: "{{name}}"
    - name: vars demo2
      debug:
        msg: "{{password}}"
```

```sh
#passing variables at runtie
ansible-playbook vars.yml --extra-vars name=runtime
ansible-playbook vars.yml --extra-vars name="runtime"
```

---

# Ansible Inventory

Ansible inventory is a crucial part of Ansible's architecture. It lists all the systems (hosts) that you will manage with Ansible. These systems can be organized into groups and can have variables assigned to them. Ansible can use static inventory files or dynamic inventory scripts to gather information about your infrastructure.

## Static Inventory

A static inventory is a simple text file (by default named hosts or inventory) where you list your hosts and group them as needed. This file can be in INI or YAML format.

**INI Format**

```ini
# Static inventory in INI format

# Define a group of hosts
[app]
172.31.80.9
172.31.80.9 ansible_user=ec2-user ansible_ssh_private_key_file=/tmp/key.pem
172.31.80.9 ansible_user=ec2-user ansible_password=admin123

[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com
db2.example.com

# You can also define variables for hosts and groups
[webservers:vars]
http_port=80
max_clients=200

[databases:vars]
db_port=3306
db_user=admin

# You can define a host with specific variables
web3.example.com http_port=8080 max_clients=150

```

**YAML format**

```yaml
# Static inventory in YAML format

all:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
      vars:
        http_port: 80
        max_clients: 200
    databases:
      hosts:
        db1.example.com:
        db2.example.com:
      vars:
        db_port: 3306
        db_user: admin
    ungrouped:
      hosts:
        web3.example.com:
          http_port: 8080
          max_clients: 150
```

## dynamic inventory

A dynamic inventory is a script or a program that dynamically generates the inventory data. This is useful for environments where the infrastructure is constantly changing, such as cloud environments. Ansible supports various dynamic inventory plugins for different platforms like AWS, Azure, Google Cloud, and more.

### using the inventory

Install the python packages (boto3 and botocore) for the ansible user

```sh
# Option 1: Using pip with the --user flag to install packages for the ansible user
sudo yum -y install python3-pip
pip3 install boto3 botocore --user
pip3 install --upgrade requests --user
# Option 2: Using apt to install system-wide packages (these packages will be available for all users). use the below command for ubuntu or debian based system since apt manages python environment to avoid conflicts
sudo apt -y install python3-pip
sudo apt-get update
sudo apt-get install python3-boto3
sudo apt-get install python3-requests
```

To use the inventory in your Ansible commands, you specify the -i option followed by the path to your inventory file:

test.yml

```yml
---
- name: Test Playbook
  hosts: all
  become: true
  tasks:
    - name: Ensure Python is installed
      apt:
        name: python3
        state: present

    - name: Install boto3 and botocore
      pip:
        name:
          - boto3
          - botocore
        state: latest

    - name: Upgrade requests
      pip:
        name: requests
        state: latest
```

di-aws_ec2.yml

```yaml
plugin: aws_ec2
aws_access_key: your_aws_access_key #or assign iam role to ansible server for more security
aws_secret_key: your_aws_secret_key
regions:
  - us-east-2
filters:
  instance-state-name: running
keyed_groups:
  - key: tags.Name
    prefix: ""
    separator: ""
hostnames:
  - private-ip-address
compose:
  ansible_host: private_ip_address
```

```sh
#to execute the above playbook with the inventory file
ansible-playbook test.yml -i di-aws_ec2.yml -u ubuntu --private-key=/tmp/key.pem

# Ping all hosts in the inventory
ansible -i /path/to/inventory all -m ping

# Run a playbook using the inventory
ansible-playbook -i /path/to/inventory playbook.yml

# List specified resources in the inventory file (for AWS)
ansible-inventory --graph -i fileName-aws_ec2.yml

#we could add -l or --limit to limit the results of specific servers by pasing the name of the server
ansible-playbook test.yml -i di-aws_ec2.yml -u ubuntu --private-key=/tmp/key.pem -l master
```

# Ansible Roles

Ansible roles are a way to organize playbooks and related files to facilitate reuse and sharing of Ansible content. Roles allow you to break down your Ansible playbooks into reusable components. Each role is essentially a collection of tasks, variables, files, templates, and handlers organized in a specific directory structure. This makes your Ansible code more modular, maintainable, and easier to understand.

## Roles directory structure

```python
myrole/
├── defaults
│   └── main.yml       # Default variables for the role
├── files
│   └── ...            # Files to be deployed by the role
├── handlers
│   └── main.yml       # Handlers for the role
├── meta
│   └── main.yml       # Role metadata
├── tasks
│   └── main.yml       # Tasks for the role
├── templates
│   └── ...            # Templates to be deployed by the role
├── tests
│   └── ...            # Test playbooks for the role
└── vars
    └── main.yml       # Other variables for the role
```
