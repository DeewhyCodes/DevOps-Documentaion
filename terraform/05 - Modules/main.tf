module "ec2_module" {
  source = "./ec2"
}


#settings
terraform {
  required_version = "~> 1.0" #any version equal or above 1.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#provider
provider "aws" {
  region = var.us_region #call the region variable
}

#declare region variable
variable "us_region" {
  type    = string
  default = "us-east-1"
}