/*The depends_on meta-argument is used to specify dependencies explicitly. 
This ensures that Terraform understands the order in which resources should be created,
 modified, or destroyed.
 */

#3) resource block, to create the instance
resource "aws_instance" "test_ec2" {
  ami           = var.my_ami 
  instance_type = var.my_instance_type[0] 
  
  subnet_id = aws_subnet.test_subnet.id
   
   depends_on = [ aws_vpc.test_vpc ] #this specifies that this instance depends on the subnet attributes from which it will be created

  tags = {
    Name = var.my_instance_name
  }
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Test-vpc"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Test-subnet"
  }
}
