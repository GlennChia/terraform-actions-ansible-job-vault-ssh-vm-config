# Ansible playbook to cleanup base resources

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: Run the following to cleanup the AAP resources like credentials, project, inventory, job template.

```bash
ansible-playbook playbook.yml
```
