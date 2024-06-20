#script to create a simple role folder structure

#!/bin/bash

# Create the directory structure
mkdir -p myrole/defaults
mkdir -p myrole/files
mkdir -p myrole/handlers
mkdir -p myrole/meta
mkdir -p myrole/tasks
mkdir -p myrole/templates
mkdir -p myrole/tests
mkdir -p myrole/vars

# Create and populate the default variables file
cat <<EOL > myrole/defaults/main.yml
---
# Default variables for the role
apache_package: apache2
EOL

# Create and populate a sample file
cat <<EOL > myrole/files/sample_file.txt
This is a sample file to be deployed.
EOL

# Create and populate the handlers file
cat <<EOL > myrole/handlers/main.yml
---
# Handlers for the role
- name: Restart Apache
  service:
    name: apache2
    state: restarted
EOL

# Create and populate the metadata file
cat <<EOL > myrole/meta/main.yml
---
# Role metadata
galaxy_info:
  author: Your Name
  description: This is a sample role
  company: Your Company
  license: MIT
  min_ansible_version: 2.9

dependencies: []
EOL

# Create and populate the tasks file
cat <<EOL > myrole/tasks/main.yml
---
# Tasks for the role
- name: Install Apache
  apt:
    name: "{{ apache_package }}"
    state: present
  notify:
    - Restart Apache

- name: Deploy sample file
  copy:
    src: sample_file.txt
    dest: /tmp/sample_file.txt

- name: Deploy sample template
  template:
    src: sample_template.j2
    dest: /tmp/sample_output.txt
EOL

# Create and populate the template file
cat <<EOL > myrole/templates/sample_template.j2
This is a sample template.
The value of apache_package is {{ apache_package }}.
EOL

# Create and populate the test playbook
cat <<EOL > myrole/tests/test.yml
---
- hosts: localhost
  roles:
    - myrole
EOL

# Create and populate the vars file
cat <<EOL > myrole/vars/main.yml
---
# Other variables for the role
custom_message: "Hello, Ansible!"
EOL
