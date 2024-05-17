/*Data sources in terraform are powerful features, enabling you to integrate with external system, fetch
dynamic data, and create more flexible and scalable infrastructure configurations
*/
provider "aws" {
  
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = ["767397803854"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}