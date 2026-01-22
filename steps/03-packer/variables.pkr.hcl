variable "vault_ssh_ca_public_key" {
  type        = string
  description = "HashiCorp Vault SSH CA public key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "AWS region to build the AMI"
  default     = "us-east-1"
}

variable "ami_name_prefix" {
  type        = string
  description = "Prefix for the AMI name"
  default     = "al2023-vault-ssh-ca"
}
