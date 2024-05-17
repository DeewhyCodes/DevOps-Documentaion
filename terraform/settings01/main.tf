# using terraform  high level block syntax, create an ec2-instance and use a userdata to set up and install apache,
# also attach an elastic IP to the instance

#1) settings block
terraform {
  required_version = "~> 1.0" #any version equal or above 1.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#2) providers block
provider "aws" {
  region = "us-east-1"
}

#3) resource block, to create the instance
resource "aws_instance" "test_ec2" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"

  user_data = file("${path.module}/apache-install.sh")
  tags = {
    Name = "Ec2-Demo"
  }
}

#4)resource block, to create an elastic IP resource
resource "aws_eip" "my_eip" {
  instance = aws_instance.test_ec2.id
}