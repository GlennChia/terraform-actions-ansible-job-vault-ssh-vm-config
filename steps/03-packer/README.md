# Packer configures golden image loaded with Vault SSH CA public key

Step 1: Configure AWS credentials. For example:

```bash
export AWS_ACCESS_KEY_ID=example
export AWS_SECRET_ACCESS_KEY=example
export AWS_SESSION_TOKEN=example
```

Step 2: Copy [variables.pkrvars.hcl.example](./variables.pkrvars.hcl.example) to `variables.auto.pkrvars.hcl` and adjust the variables accordingly. The value of `vault_ssh_ca_public_key` is retrieved from the output of the terraform apply in [02-tf-vault-config](../02-tf-vault-config/)

Step 3: Initialize packer and build the image

```bash
packer init .
packer build .
```
