#https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  create_igw = false #we can pass some values to specify which resources should be created or not
}