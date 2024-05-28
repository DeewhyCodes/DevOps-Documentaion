/*
The count meta-argument allows you to create multiple instances of a resource or module.
This helps us reduce repetition of codes which is a good practice

The limitation of the count meta_argument is that once the first or middle member of the list
is taken out, it causes a distruption of the index which they were previously arranged.
 */

#3) resource block, to create the instance
resource "aws_instance" "test_ec2" {

  #count = 3  #this is going to create 3 test_ec2 instance
  count = length(var.demo_count) #this will iterrate through the number of variables 
  #in demo count and create same amount of test_ec2 instances 

  ami           = var.my_ami 
  instance_type = var.my_instance_type[0] 

  tags = {
    #Name = "Demo_ec2 ${count.index}"  #this will create 3 instance, and we can defferentiate them by mapping through the count index
    Name = var.demo_count[count.index] #this will apply the demo_count variables based on their index
  }
}

#we can also pass a list of attributes to the count instances by creating a list variables
variable "demo_count" {
  type = list(string)
  default = [ "dev", "stage", "uat", "prod" ]
}



