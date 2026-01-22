data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}

data "terraform_remote_state" "vault_config" {
  backend = "local"

  config = {
    path = "../02-tf-vault-config/terraform.tfstate"
  }
}
