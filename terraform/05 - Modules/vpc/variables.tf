#Variables configuration file

variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "sub_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "subnet_name" {
  type = string
  default = "Test_Subnet"
}
variable "vpc_name" {
  type = string
  default = "Test_VPC"
}

/*locals block syntax is used to define local values that can be used within a module*/
locals {
  vpc_name = var.vpc_name
  subnet_name = var.subnet_name
}



#declare instance_name
variable "my_instance_name" {
  type = string
  default = "Ec2-Demo"
}