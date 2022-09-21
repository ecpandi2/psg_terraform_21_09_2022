data "aws_caller_identity" "current" {
}
locals {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  profile = local.profile
  region  = local.region
}

module "backend" {
  source                   = "./modules/remote" //local remote module
  backend_bucket           = "horizon-tf-main-terraform-states"
  dynamodb_lock_table_name = "horizon-tf-main-terraform-backend-locks"
}
