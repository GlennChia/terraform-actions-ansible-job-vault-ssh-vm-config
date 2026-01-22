terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.11"
}

provider "vault" {
  address   = data.terraform_remote_state.vault_base.outputs.hcp_vault_public_endpoint_url
  namespace = var.vault_namespace
  token     = data.terraform_remote_state.vault_base.outputs.hcp_vault_cluster_admin_token
}