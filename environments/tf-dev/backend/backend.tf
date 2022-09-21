
data "aws_caller_identity" "current" {
}

locals {
  profile = var.profile
  region  = var.region
}

# AWS provider with region us-east-1. profile will not be required
provider "aws" {
  profile = local.profile
  region = local.region
}

# Terraform Backend to be created. S3 creation and dynamodb table creation will be done through "remote" module.
module "backend" {
  source                   = "../../../modules/remote" //local remote module
  backend_bucket           = "psg-tf-dev-terraform-states-eks-pandiyan"
  dynamodb_lock_table_name = "psg-tf-dev-terraform-backend-locks-eks-pandiyan"
}
