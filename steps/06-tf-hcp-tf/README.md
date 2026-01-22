# Create Terraform workspace for testing actions with AAP

Step 1: Generate HCP Terraform credentials. Refer to the [tfe_provider authentication docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication) for the various token options and guidance. Copy [terraform.tfvars.example](./terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly. GitHub credentials can use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). This token needs sufficient permissions to create, delete repositories, and write files to the repository.

> [!CAUTION]
> In a live environment, it is not good practice to directly pass the GitHub token, HCP TF Token, or AAP password. Instead, sensitive credentials should be securely stored and accessed using solutions like HashiCorp Vault, which provides encrypted storage and access controls capabilities.

Step 2: Run an apply, review the plan output, and approve the plan accordingly.

```bash
terraform init
terraform apply
```