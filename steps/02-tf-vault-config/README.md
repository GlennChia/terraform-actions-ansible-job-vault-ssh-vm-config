# Configure Vault SSH Secrets Engine with AppRole

Step 1: Run an apply, review the plan output, and approve the plan accordingly.

> [!NOTE]
> If there are permission errors during the apply, navigate back to [01-tf-hcp-vault](../01-tf-hcp-vault/) and run a `terraform apply` in that directory. This refreshes the Vault admin token that is used to configure Vault

```bash
terraform init
terraform apply
```
