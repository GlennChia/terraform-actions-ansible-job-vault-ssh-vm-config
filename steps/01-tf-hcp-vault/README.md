# Create a HCP Vault cluster

Step 1: Configure HCP credentials. For example:

```bash
export HCP_CLIENT_ID=example
export HCP_CLIENT_SECRET=example
export HCP_PROJECT_ID=example
```

Step 2: Copy [terraform.tfvars.example](./terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly.

Step 3: Run an apply, review the plan output, and approve the plan accordingly. The apply outputs the HCP Vault admin token that will be used to configure Vault in [02-tf-vault-config](../02-tf-vault-config/).

> [!CAUTION]
> In a live environment it is not good practice to output the Vault admin token. The token is output in this repo purely for demo purposes, such that readers can easily pass the token to the Vault provider in [02-tf-vault-config/providers.tf](../02-tf-vault-config/providers.tf).

```bash
terraform init
terraform apply
```