/*Data sources in terraform are powerful features, enabling you to integrate with external system, fetch
dynamic data, and create more flexible and scalable infrastructure configurations. This helps us reduce hardcoding 
*/
provider "aws" {
  
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true #if more than one result is returned, use most_recent = true.
  owners = ["767397803854"] #if it is you who created it, you can pass "self" as the value

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

/*
this data is going to fetch the most recent ubuntu instance matching the spec from the owner account specified
 the ami ID attribute can be called in the resource file using (ami = data.aws_ami.ubuntu_ami.id)
 */