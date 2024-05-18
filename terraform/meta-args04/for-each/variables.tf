#Variables configuration file

#declare region variable
variable "us_region" {
  type = string
  default = "us-east-1" #if we don't enter a default value, then an input value would be requested during terraform plan
}
#declare ami variable
variable "my_ami" {
  type = string
  default = "ami-04b70fa74e45c3917"
}
#declare instance_type variable
variable "my_instance_type" {
  type = list(string) #passing the variables as a list of strings 
  default = ["t2.micro", "t2.medium", "t3.micro"] #the array of strings to be selected by their index
}



#declare instance_name
variable "my_instance_name" {
  type = string
  default = "Ec2-Demo"
}