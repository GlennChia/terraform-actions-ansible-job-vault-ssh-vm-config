resource "vault_mount" "ssh_client_signer" {
  path        = "ssh-client-signer"
  type        = "ssh"
  description = "SSH client key signing"
}

resource "vault_ssh_secret_backend_ca" "ssh_ca" {
  backend              = vault_mount.ssh_client_signer.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "client_role" {
  name                    = "demo-role"
  backend                 = vault_mount.ssh_client_signer.path
  key_type                = "ca"
  algorithm_signer        = "rsa-sha2-256"
  allow_user_certificates = true
  allowed_users           = "ec2-user"
  allowed_extensions      = "permit-pty,permit-port-forwarding"
  default_extensions = {
    "permit-pty" = ""
  }
  default_user = "ec2-user"
  ttl          = "1800"
}
