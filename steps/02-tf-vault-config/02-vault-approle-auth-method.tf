resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

resource "vault_policy" "ssh_signing_policy" {
  name = "ssh-signing-policy"

  policy = <<EOF
path "${vault_mount.ssh_client_signer.path}/sign/${vault_ssh_secret_backend_role.client_role.name}" {
  capabilities = ["read", "update"]
}
EOF
}

resource "vault_approle_auth_backend_role" "this" {
  backend        = vault_auth_backend.approle.path
  role_name      = "example-role"
  token_policies = [vault_policy.ssh_signing_policy.name]

  token_ttl     = 3600  # 1 hour
  token_max_ttl = 86400 # 1 day
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.this.role_name
}