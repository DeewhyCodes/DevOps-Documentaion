/*
The for_each meta-argument allows you to iterate over a set of values to create multiple instances of a resource or module.
It's more flexible than 'count' because it can use maps and sets.
 */

# Define a resource block to create multiple EC2 instances
resource "aws_instance" "test_ec2" {

  for_each = toset(var.demo_count) # This will iterate through the values in the set created from the demo_count variable
                                   # and create an EC2 instance for each value

  ami           = var.my_ami  
  instance_type = var.my_instance_type[0] # Instance type to use for the EC2 instances, taking the first element from a list variable

  tags = {
    Name = each.value  # Tag each instance with a name based on the current value from the demo_count set
  }
}

# Define a variable to hold a list of environment names
variable "demo_count" {
  type    = list(string) # The variable type is a list of strings
  default = [ "dev", "stage", "uat", "prod" ] # Default values for the demo_count variable, representing different environments
}




