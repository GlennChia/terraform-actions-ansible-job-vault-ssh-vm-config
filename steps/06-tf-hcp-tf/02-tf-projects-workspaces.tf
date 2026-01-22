resource "tfe_project" "this" {
  organization = var.tf_organization_name
  name         = "aap"
}

resource "tfe_oauth_client" "github" {
  organization        = var.tf_organization_name
  organization_scoped = true # Whether or not the oauth client is scoped to all projects and workspaces in the organization. Defaults to true
  api_url             = "https://api.github.com"
  http_url            = "https://github.com"
  oauth_token         = var.github_token
  service_provider    = "github"
}

resource "tfe_workspace" "this" {
  depends_on = [github_repository_file.variables_tf]

  name                = local.workspace_name
  organization        = var.tf_organization_name
  queue_all_runs      = false # Whether the workspace should start automatically performing runs immediately after its creation. Set to false because initial commit fails
  project_id          = tfe_project.this.id
  force_delete        = true
  assessments_enabled = true
  auto_apply          = false
  terraform_version   = "1.14.3"

  vcs_repo {
    branch         = local.github_branch
    identifier     = github_repository.this.full_name
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}
