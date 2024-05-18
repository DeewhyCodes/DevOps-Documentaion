/*Data sources in terraform are powerful features, enabling you to integrate with external system, fetch
dynamic data, and create more flexible and scalable infrastructure configurations. This helps us reduce hardcoding 
*/

data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-9.2.0_HVM-*-GP2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}