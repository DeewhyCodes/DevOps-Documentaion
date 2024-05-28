#providers configuration file 

#1) settings block
terraform {
  required_version = "~> 1.0" #any version equal or above 1.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#2) providers block
provider "aws" {
  region = var.us_region #call the region variable
}
