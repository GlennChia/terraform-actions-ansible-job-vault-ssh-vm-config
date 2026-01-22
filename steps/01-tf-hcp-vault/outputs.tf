output "hcp_vault_public_endpoint_url" {
  description = "The public URL for the HCP Vault cluster"
  value       = hcp_vault_cluster.this.vault_public_endpoint_url
}

output "hcp_vault_cluster_admin_token" {
  description = "The Admin Token for the HCP Vault Cluster"
  value       = nonsensitive(hcp_vault_cluster_admin_token.this.token)
}
