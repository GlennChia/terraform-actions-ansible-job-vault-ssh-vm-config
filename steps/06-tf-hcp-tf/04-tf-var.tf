# Variable set for AWS OIDC
resource "tfe_variable_set" "aws_oidc" {
  name         = "aws-oidc"
  description  = "AWS OIDC variables"
  organization = var.tf_organization_name
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  key             = "TFC_AWS_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  description     = "boolean to enable OIDC AWS provider auth"
  variable_set_id = tfe_variable_set.aws_oidc.id
}

resource "tfe_variable" "tfc_aws_run_role_arn" {
  sensitive       = true
  key             = "TFC_AWS_RUN_ROLE_ARN"
  value           = aws_iam_role.tf_workspace.arn
  category        = "env"
  description     = "IAM Role ARN to assume via OIDC auth"
  variable_set_id = tfe_variable_set.aws_oidc.id
}

resource "tfe_project_variable_set" "basic_to_aws_oidc" {
  project_id      = tfe_project.this.id
  variable_set_id = tfe_variable_set.aws_oidc.id
}

# Variable set for TF resources
resource "tfe_variable_set" "tf_resources" {
  name         = "tf-resources-variables"
  description  = "Terraform resource variables"
  organization = var.tf_organization_name
}

resource "tfe_variable" "aws_region" {
  key             = "region"
  value           = var.region
  category        = "terraform"
  description     = "AWS Region to deploy resources into"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_variable" "aap_host" {
  key             = "aap_host"
  value           = var.aap_host
  category        = "terraform"
  description     = "AAP Host URL"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_variable" "aap_username" {
  key             = "aap_username"
  value           = var.aap_username
  category        = "terraform"
  description     = "AAP Username"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_variable" "aap_password" {
  key             = "aap_password"
  value           = var.aap_password
  category        = "terraform"
  description     = "AAP Password"
  variable_set_id = tfe_variable_set.tf_resources.id
  sensitive       = true
}

resource "tfe_variable" "aap_inventory_name" {
  key             = "aap_inventory_name"
  value           = var.aap_inventory_name
  category        = "terraform"
  description     = "AAP Inventory name to deploy the hosts to"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_variable" "allowed_ip" {
  key             = "allowed_ip"
  value           = var.allowed_ip
  category        = "terraform"
  description     = "IP address allowed to SSH into the EC2 instance"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_variable" "var_from_tf_aap_job_launch" {
  key             = "var_from_tf_aap_job_launch"
  value           = var.var_from_tf_aap_job_launch
  category        = "terraform"
  description     = "Variable to pass to the AAP Job Template"
  variable_set_id = tfe_variable_set.tf_resources.id
}

resource "tfe_project_variable_set" "this_to_tf_resources" {
  project_id      = tfe_project.this.id
  variable_set_id = tfe_variable_set.tf_resources.id
}