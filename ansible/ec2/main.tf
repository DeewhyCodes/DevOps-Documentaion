provider "aws" {

}

resource "aws_instance" "ansible" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.micro"
  subnet_id       = "subnet-030c60b43b59dfed7"
  key_name        = "mavenKey"
  security_groups = ["sg-0c0e098bcffb41933"]
  tags = {
    Name = "ansible"
  }
}