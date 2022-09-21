# Terraform backend reference.
terraform {
  backend "s3" {
    bucket         = "psg-tf-dev-terraform-states-eks-pandiyan"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "psg-tf-dev-terraform-backend-locks-eks-pandiyan"
    profile        = "default"
  }
}

# Use this data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized.
data "aws_caller_identity" "current" {}

locals {
  env            = terraform.workspace # dev, tst, stg, pro, test
  profile        = var.profile
  stage          = substr(terraform.workspace, 0, 3) # dev, stg, prd
  aws_account_id = data.aws_caller_identity.current.account_id
  region         = var.region
}

# aws provider with provided profile and region
provider "aws" {
  profile = local.profile
  region = local.region
}

# config module calling to intialize the variables
module "config" {
  source = "../../modules/config"
}
