#https://registry.terraform.io/modules/boldlink/ec2/aws/latest
module "ec2" {
  source  = "boldlink/ec2/aws"
  version = "2.0.7"
}