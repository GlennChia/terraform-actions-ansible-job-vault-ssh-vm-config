# Terraform Actions to launch Ansible Automation Platform (AAP) Jobs for VM configuration with secure SSH via Vault SSH Secrets Engine

# 1. Architecture

![architecture diagram](./docs/01-architecture/01-architecture-diagram.png)

- Packer builds a golden EC2 AMI with the Vault SSH CA public key pre-configured as a trusted certificate authority
- Terraform applies the configuration and provisions an EC2 instance from the golden AMI
- Terraform creates an AAP host resource with the EC2 instance public IP and triggers the [aap_job_launch](https://registry.terraform.io/providers/ansible/aap/latest/docs/actions/job_launch) action. This demo also shows how variables can be passed from the action to the playbook via the `extra_vars` argument. This pattern can be found at [03-aap.tf](./steps/06-tf-hcp-tf/tf-github-bootstrap/03-aap.tf).
- AAP job template executes the playbook against the remote host using Vault Signed SSH credentials to access the host

# 2. Deployment

## 2.1 HCP Vault

Step 1: Configure HCP credentials. For example:

```bash
export HCP_CLIENT_ID=example
export HCP_CLIENT_SECRET=example
export HCP_PROJECT_ID=example
```

Step 2: Copy [terraform.tfvars.example](./steps/01-tf-hcp-vault/terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly.

Step 3: Run an apply, review the plan output, and approve the plan accordingly. The apply outputs the HCP Vault admin token that will be used to configure Vault in [02-tf-vault-config](./steps/02-tf-vault-config/).

> [!CAUTION]
> In a live environment it is not good practice to output the Vault admin token. The token is output in this repo purely for demo purposes, such that readers can easily pass the token to the Vault provider in [02-tf-vault-config/providers.tf](./steps/02-tf-vault-config/providers.tf).

```bash
terraform init
terraform apply
```

## 2.2 Vault config with SSH secrets engine

Run an apply, review the plan output, and approve the plan accordingly.

> [!NOTE]
> If there are permission errors during the apply, navigate back to [01-tf-hcp-vault](./steps/01-tf-hcp-vault/) and run a `terraform apply` in that directory. This refreshes the Vault admin token that is used to configure Vault

```bash
terraform init
terraform apply
```

## 2.3 Packer build golden image with Vault SSH CA public key

Step 1: Copy [variables.pkrvars.hcl.example](./steps/03-packer/variables.pkrvars.hcl.example) to `variables.auto.pkrvars.hcl` and adjust the variables accordingly. The value of `vault_ssh_ca_public_key` is retrieved from the output of the terraform apply in [02-tf-vault-config](./steps/02-tf-vault-config/)

Step 2: Initialize packer and build the image

```bash
packer init .
packer build .
```

![packer build](./docs/02-deployment/03-packer/01-packer-build.png)

## 2.4 GitHub repo with Ansible playbook

Step 1: Copy [terraform.tfvars.example](./steps/04-tf-github-ansible-playbook/terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly. GitHub credentials can use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). This token needs sufficient permissions to create, delete repositories, and write files to the repository.

Step 2: Run an apply, review the plan output, and approve the plan accordingly. The apply outputs the GitHub repository's HTML URL. This is used for `scm_url` in [05-ansible-aap-base/extra_vars.yml](./steps/05-ansible-aap-base/extra_vars.yml)

> [!CAUTION]
> In a live environment, it is not good practice to directly pass the GitHub token. Instead, sensitive credentials should be securely stored and accessed using solutions like HashiCorp Vault, which provides encrypted storage and access controls capabilities.

```bash
terraform init
terraform apply
```

## 2.5 AAP base

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: Copy [extra_vars.yml.example](./steps/05-ansible-aap-base/extra_vars.yml.example) to `extra_vars.yml` and replace the values accordingly. These values are retrieved from the Terraform outputs in [02-tf-vault-config](./steps/02-tf-vault-config) and [04-tf-github-ansible-playbook](./steps/04-tf-github-ansible-playbook/).

Step 3: Run the following to setup the AAP resources like credentials, project, inventory, host, job template.

```bash
ansible-playbook -e @extra_vars.yml playbook.yml
```

# 3. Verify

## 3.1 HCP Vault

Cluster overview

> [!CAUTION]
> It is recommended to disable public access to the Vault cluster in a production environment unless there is a use case that requires it. In those cases, it is [recommended to configure the IP allow list](https://developer.hashicorp.com/vault/tutorials/get-started-hcp-vault-dedicated/vault-access-cluster#access-the-vault-cluster) to limit which IPv4 public IP addresses or CIDR ranges can connect to Vault.

![cluster overview](./docs/02-deployment/01-hcp-vault/01-cluster-overview.png)

## 3.2 Vault configurations

Login to Vault

![vault login](./docs/02-deployment/02-vault-config/01-vault-login.png)

### 3.2.1 SSH secrets engine

View the secrets engines. This shows the SSH secrets engine at the `ssh-client-signer` path

![secrets engines](./docs/02-deployment/02-vault-config/02-secrets-engines.png)

The secrets engine configuration shows the Vault CA public key. This key must be added as a trusted CA to the golden image created. This allows vault signed SSH keys to be used for SSH into the VM launched from the golden image.

![secrets engine configuration](./docs/02-deployment/02-vault-config/03-secrets-engine-configuration.png)

A role is created for the secrets engine.

![secrets engine roles](./docs/02-deployment/02-vault-config/04-secrets-engine-roles.png)

Role configuration to sign SSH keys

![secrets engine role sign ssh key](./docs/02-deployment/02-vault-config/05-secrets-engine-role-sign-ssh-key.png)

### 3.2.2 AppRole auth method

View the AppRole auth method configuration

![approle auth method configuration](./docs/02-deployment/02-vault-config/06-approle-auth-method-configuration.png)

AppRole role details showing the attached policy

![approle role details](./docs/02-deployment/02-vault-config/07-approle-role-details.png)

Policy permissions for SSH key signing

![policy](./docs/02-deployment/02-vault-config/08-policy.png)

## 3.3 Packer golden image

View the golden image created.

![image storage](./docs/02-deployment/03-packer/02-image-storage.png)

## 3.4 GitHub repo with ansible playbook

View the GitHub repository containing the Ansible playbook

![github repo playbook](./docs/02-deployment/04-github-repo-playbook/01-github-repo-playbook.png)

## 3.5 AAP base

### 3.5.1 AAP project

Project details showing the synced GitHub repository

![project details](./docs/02-deployment/05-aap/01-project/01-project-details.png)

Job templates associated with this project

![project job templates](./docs/02-deployment/05-aap/01-project/02-project-job-templates.png)

### 3.5.2 AAP credentials

View the credentials created for Vault AppRole and SSH

![credentials](./docs/02-deployment/05-aap/02-credential/01-credentials.png)

AppRole credential details for authenticating to Vault

![approle credential details](./docs/02-deployment/05-aap/02-credential/02-approle-credential-details.png)

There are no job templates using the AppRole credential. This is because the job template uses the Vault SSH Machine credential instead.

![approle credential job templates](./docs/02-deployment/05-aap/02-credential/03-approle-credential-job-templates.png)

Vault Signed SSH credential details for signed SSH key authentication.

![vault ssh credential details](./docs/02-deployment/05-aap/02-credential/04-vault-ssh-credential-details.png)

The demo job template uses the Vault Signed SSH credential.

![vault ssh credential job templates](./docs/02-deployment/05-aap/02-credential/05-vault-ssh-credential-job-templates.png)

### 3.5.3 AAP inventory

Inventory details.

![details](./docs/02-deployment/05-aap/03-inventory/01-details.png)

There are no hosts registered in the inventory yet.

![hosts](./docs/02-deployment/05-aap/03-inventory/02-hosts.png)

The demo job template is associated with this inventory.

![job templates](./docs/02-deployment/05-aap/03-inventory/03-job-templates.png)

### 3.5.4 AAP job template details

Job template configuration with project, inventory, and credentials

![template details](./docs/02-deployment/05-aap/04-job-template/01-template-details.png)

# 4. Testing

Step 1: Generate HCP Terraform credentials. Refer to the [tfe_provider authentication docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication) for the various token options and guidance. Copy [terraform.tfvars.example](./steps/06-tf-hcp-tf/terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly. The variable `var_from_tf_aap_job_launch` determines the custom value passed from the Terraform action to the Ansible playbook that eventually shows up in the custom Nginx UI. GitHub credentials can use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). This token needs sufficient permissions to create, delete repositories, and write files to the repository.

> [!CAUTION]
> In a live environment, it is not good practice to directly pass the GitHub token, HCP TF Token, or AAP password. Instead, sensitive credentials should be securely stored and accessed using solutions like HashiCorp Vault, which provides encrypted storage and access controls capabilities.

Step 2: Run an apply, review the plan output, and approve the plan accordingly.

```bash
terraform init
terraform apply
```

Verify the created GitHub repository with Terraform configuration.

![github repo](./docs/02-deployment/05-aap/05-workspace/01-github-repo.png)

HCP Terraform workspace overview.

![workspace overview](./docs/02-deployment/05-aap/05-workspace/02-workspace-overview.png)

Workspace variables configured.

![workspace variables](./docs/02-deployment/05-aap/05-workspace/03-workspace-variables.png)

Back in workspace overview, choose `New run`.

![workspace overview](./docs/03-testing/01-workspace-overview.png)

Start a new run.

![start a new run](./docs/03-testing/02-start-a-new-run.png)

Plan finished showing the resources to be created and 1 action to invoke.

![plan finished](./docs/03-testing/03-plan-finished.png)

Zoom in on the action. In addition, validate that the `aws_instance.tf_app` uses the golden image created earlier.

![plan finished action ec2](./docs/03-testing/04-plan-finished-action-ec2.png)

Confirm the apply and verify that the apply is running.

![apply running start](./docs/03-testing/05-apply-running-start.png)

EC2 instance being created

![apply running instance creating](./docs/03-testing/06-apply-running-instance-creating.png)

After the EC2 instance is created, Terraform adds it as a host in AAP.

![aap host](./docs/03-testing/07-aap-host.png)

Once the host is added, the Terraform `aap_job_launch` action starts a job.

![playbook running](./docs/03-testing/08-playbook-running.png)

Terraform apply logs showing AAP host created and action starting. You might have to refresh your browser to see this.

![aap host created action starting](./docs/03-testing/09-aap-host-created-action-starting.png)

Eventually the apply finishes and the action successfully invoked the AAP job. Note the public IP of the host. Use this to verify that the host is configured based on the playbook definition.

![apply finished action invoked](./docs/03-testing/12-apply-finished-action-invoked.png)

AAP job output showing successful playbook execution.

![playbook output](./docs/03-testing/13-playbook-output.png)

Job details showing successful completion.

![playbook details](./docs/03-testing/14-playbook-details.png)

Enter the EC2 instance public IP in the browser and verify that Nginx is deployed and accessible. This also includes the custom `hello from Terraform` input passed from the [aap_job_launch](https://registry.terraform.io/providers/ansible/aap/latest/docs/actions/job_launch) action to the playbook.

![nginx ui](./docs/03-testing/15-nginx-ui.png)
