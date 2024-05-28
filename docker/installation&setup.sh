#!/bin/sh
sudo hostnamectl set-hostname docker
sudo apt update -y
sudo apt install docker.io -y
sudo service docker start
sudo docker info
sudo usermod -aG docker ubuntu #in order to run docker command without using sudo. this part will add docker to the grp.
sudo su - ubuntu
sudo docker ps

NOTE: YOU WILL GET PERMISSION DENIED ERROR AS A REGULAR USER DOESN'T HAVE PERMISSIONS TO EXECUTE DOCKER COMMANDS. ADD THE REGULAR USER TO THE DOCKER GROUP. 
  sudo usermod -aG docker $USER
        OR
  sudo usermod -aG docker Ubuntu

THEN EXIT FROM THE CURRENT SSH TERMINAL & SSH(LOGIN) AGIN. THEN EXECUTE docker ps. 
  sudo su - ubuntu

---------------------------------------------------------------------------------------------------------

***BEST WAY TO INSTALL DOCKER:

#!/bin/sh
sudo hostnamectl set-hostname docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo systemctl start docker 
sudo usermod -aG docker ubuntu
sudo su - ubuntu
sudo systemctl status docker

