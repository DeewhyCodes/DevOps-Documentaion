/*
Terraform modules are reusable, self-contained packages of terraform configurations that can be used to manage
infrastructure resources. They can be stored locally or remotely (e.g., Terraform Registry, GitHub).
*/

#3) resource block, to create the instance
resource "aws_instance" "test_ec2" {
  ami           = var.my_ami
  instance_type = var.my_instance_type[0] 
  #user_data = file("${path.module}/apache-install.sh")

  subnet_id = module.vpc.subnet_id #get the subnet_id comming from the subnet_id output in the vpc module


  tags = {
    Name = var.my_instance_name
  }
}

#4)resource block, to create an elastic IP resource
resource "aws_eip" "my_eip" {
  instance = aws_instance.test_ec2.id
}

#for this test_ec2 to be able to access the subnet_id which is comming from another module (vpc)
#we need to call the vpc as a child module of this ec2 module
module "vpc" {
  source = "../vpc" #path to the vpc module.
}
