resource "github_repository" "this" {
  name               = "hcp-tf-vm-config-aap-demo"
  description        = "repo created to demo HCP TF integration with AAP"
  auto_init          = true # produces an initial commit
  gitignore_template = "Terraform"
  visibility         = "private"
}

resource "github_repository_file" "network_tf" {
  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: aws network"
  overwrite_on_create = true
  file                = "01-network.tf"
  content             = file("./tf-github-bootstrap/01-network.tf")
}

resource "github_repository_file" "ec2_tf" {
  depends_on = [github_repository_file.network_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: ec2 instance"
  overwrite_on_create = true
  file                = "02-ec2.tf"
  content             = file("./tf-github-bootstrap/02-ec2.tf")
}

resource "github_repository_file" "aap_tf" {
  depends_on = [github_repository_file.ec2_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: ansible automation platform resources"
  overwrite_on_create = true
  file                = "03-aap.tf"
  content             = file("./tf-github-bootstrap/03-aap.tf")
}

resource "github_repository_file" "data_tf" {
  depends_on = [github_repository_file.aap_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: data sources"
  overwrite_on_create = true
  file                = "data.tf"
  content             = file("./tf-github-bootstrap/data.tf")
}

resource "github_repository_file" "locals_tf" {
  depends_on = [github_repository_file.data_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: local variables"
  overwrite_on_create = true
  file                = "locals.tf"
  content             = file("./tf-github-bootstrap/locals.tf")
}

resource "github_repository_file" "outputs_tf" {
  depends_on = [github_repository_file.locals_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: outputs"
  overwrite_on_create = true
  file                = "outputs.tf"
  content             = file("./tf-github-bootstrap/outputs.tf")
}

resource "github_repository_file" "providers_tf" {
  depends_on = [github_repository_file.outputs_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: providers"
  overwrite_on_create = true
  file                = "providers.tf"
  content             = file("./tf-github-bootstrap/providers.tf")
}

resource "github_repository_file" "variables_tf" {
  depends_on = [github_repository_file.providers_tf]

  repository          = github_repository.this.name
  branch              = local.github_branch
  commit_message      = "feat: variables"
  overwrite_on_create = true
  file                = "variables.tf"
  content             = file("./tf-github-bootstrap/variables.tf")
}
