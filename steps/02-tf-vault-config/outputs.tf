output "ssh_ca_public_key" {
  value       = vault_ssh_secret_backend_ca.ssh_ca.public_key
  description = "Public key to be added to /etc/ssh/trusted-user-ca-keys.pem on target hosts"
}

output "approle_path" {
  description = "The path to AppRole"
  value       = vault_auth_backend.approle.path
}

output "approle_role_id" {
  description = "The Role ID for the AppRole authentication. This acts as a public identifier (similar to a username) and should be provided to the application that needs to authenticate to Vault."
  value       = vault_approle_auth_backend_role.this.role_id
}

output "approle_secret_id" {
  description = "The Secret ID for the AppRole authentication. This acts as a credential (similar to a password) and should be securely transmitted to the application. This value is marked as sensitive and will be stored in plaintext in the Terraform state file."
  value       = nonsensitive(vault_approle_auth_backend_role_secret_id.this.secret_id)
}

output "ssh_secrets_engine_path" {
  description = "The path to the SSH Secrets Engine"
  value       = vault_mount.ssh_client_signer.path
}

output "ssh_secret_backend_role_name" {
  description = "The SSH Secrets Backend Role Name"
  value       = vault_ssh_secret_backend_role.client_role.name
}

output "hcp_vault_public_endpoint_url" {
  description = "The public URL for the HCP Vault cluster"
  value       = data.terraform_remote_state.vault_base.outputs.hcp_vault_public_endpoint_url
}