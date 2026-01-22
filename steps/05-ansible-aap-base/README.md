# Ansible playbook to configure AAP resources

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: Copy [extra_vars.yml.example](./extra_vars.yml.example) to `extra_vars.yml` and replace the values accordingly. These values are retrieved from the Terraform outputs in [02-tf-vault-config](../02-tf-vault-config) and [04-tf-github-ansible-playbook](../04-tf-github-ansible-playbook/). Then run the following to setup the AAP resources like credentials, project, inventory, host, job template.

```bash
ansible-playbook -e @extra_vars.yml playbook.yml
```
