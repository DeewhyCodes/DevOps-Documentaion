# using terraform  high level block syntax, create an ec2-instance and use a userdata to set up and install apache,
# also attach an elastic IP to the instance. Pass expressions and properties use variables

#To make our work neat, we can create seperate files for the providers and variables

#3) resource block, to create the instance
resource "aws_instance" "test_ec2" {
  #ami = data.aws_ami.ubuntu_ami.id #Calling ami ID from data source file

  ami           = var.my_ami #call the ami variable

  instance_type = var.my_instance_type[0] #call the instance_type variable t2.micro by its index (0)
  #instance_type = var.my_instance_type["dev"] #to call the instance_type from a map variable.

  user_data = file("${path.module}/apache-install.sh")
  tags = {
    Name = var.my_instance_name
  }
}

#4)resource block, to create an elastic IP resource
resource "aws_eip" "my_eip" {
  instance = aws_instance.test_ec2.id
}
