data "terraform_remote_state" "vault_base" {
  backend = "local"

  config = {
    path = "../01-tf-hcp-vault/terraform.tfstate"
  }
}
