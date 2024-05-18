/*
Terraform modules are reusable, self-contained packages of terraform configurations that can be used to manage
infrastructure resources. They can be stored locally or remotely (e.g., Terraform Registry, GitHub).
*/

resource "aws_vpc" "test_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = local.vpc_name #call locals variable name
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.sub_cidr

  tags = {
    Name = local.subnet_name #call locals variable name
  }
}

output "subnet_id" {
  value = aws_subnet.test_subnet.id
}