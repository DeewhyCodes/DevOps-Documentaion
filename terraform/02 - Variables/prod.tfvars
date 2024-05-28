/* 
we could create specific tfvars files for specific environments, like dev, staging and prod...
and pass variables, we can then apply the tfvars file during the terraform plan command to load the variables
Any variables written here will overwrite default variables decalred in the variables.tf files
*/
us_region = "us-east-1"
my_instance_name = "prod_ec2"

/*if file name contains auto (prod.auto.tfvars) OR named as (terraform.tfvars)  it will be automatically loaded my terraform, 
if it doesn't contain auto, we can apply the file using {terraform plan/appply -var-file=prod.tfvars}
*/