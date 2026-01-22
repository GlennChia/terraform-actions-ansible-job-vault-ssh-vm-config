resource "github_repository" "this" {
  name               = "ansible-playbook-tf-actions-aap-demo"
  description        = "Repo with Ansible playbook that configures Nginx with a custom UI that has an optional variable var_from_tf_aap_job_launch"
  auto_init          = true # produces an initial commit
  gitignore_template = "Terraform"
  visibility         = "public"
}

resource "github_repository_file" "playbook_yml" {
  repository          = github_repository.this.name
  branch              = "main"
  commit_message      = "feat: ansible playbook"
  overwrite_on_create = true
  file                = "playbook.yml"
  content             = file("./tf-github-bootstrap-ansible-playbook/playbook.yml")
}
