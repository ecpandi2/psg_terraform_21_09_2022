data "aws_caller_identity" "current" {}

locals {
  env            = terraform.workspace                         # dev, tst, stg, pro, dem
  region         = var.region                                  # us-east-1(ireland)
  stage          = substr(terraform.workspace, 0, 3)           # dev, tst, stg, pro, dem
  aws_account_id = data.aws_caller_identity.current.account_id # aws account
  profile        = var.profile
}

provider "aws" {
  region = local.region
  # profile = local.profile
}

# config module - to access the variables defined for different aws accounts.
module "config" {
  source = "../../modules/config"
}

