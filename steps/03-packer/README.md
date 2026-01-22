# Packer configures golden image loaded with Vault SSH CA public key

Step 1: Copy [variables.pkrvars.hcl.example](./variables.pkrvars.hcl.example) to `variables.auto.pkrvars.hcl` and adjust the variables accordingly. The value of `vault_ssh_ca_public_key` is retrieved from the output of the terraform apply in [02-tf-vault-config](../02-tf-vault-config/)

Step 2: Initialize packer and build the image

```bash
packer init .
packer build .
```
