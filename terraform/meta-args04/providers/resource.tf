/*
The 'lifecycle' meta-argument allows you to control the lifecycle of a resource,
 such as preventing it from being destroyed or replaced under certain conditions.
 */

# Define a resource block to create multiple EC2 instances
resource "aws_instance" "test_ec2" {
  provider = aws.us_west 

  for_each = toset(var.demo_count) 

  ami           = var.my_ami  
  instance_type = var.my_instance_type[0]

    lifecycle {
    prevent_destroy = true  # Prevent the resource from being destroyed even when terraform destroy is ran

    ignore_changes = [
      tags,  # Ignore changes to the 'tags' attribute if made outside of Terraform
    ]
  }

  tags = {
    Name = each.value 
  }
}


variable "demo_count" {
  type    = list(string)
  default = [ "dev", "stage", "uat", "prod" ] 
}

provider "aws" {
  alias  = "us_west" 
  region = "us-west-2"  
}

#some other lifecycle arguments
/*lifecycle {
  create_before_destroy = true  # Ensure a new resource is created before the old one is destroyed
}

lifecycle {
  replace_triggered_by = [aws_ami.example.id]  # Replace the instance if the specified AMI ID changes
}

resource "aws_s3_bucket" "example" {
  lifecycle {
    retain_on_delete = true  # Do not delete the S3 bucket when removing the configuration
  }
}
*/