variable "tf_token" {
  description = "HCP TF Token"
  type        = string
  sensitive   = true
}

variable "tf_organization_name" {
  description = "Terraform Organization name to deploy resources to."
  type        = string
}

variable "github_token" {
  description = "A GitHub OAuth / Personal Access Token. When not provided or made available via the GITHUB_TOKEN environment variable, the provider can only access resources available anonymously"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region to deploy resources into"
  type        = string
}

variable "terraform_url" {
  type        = string
  description = "Terraform Cloud URL or Terraform Enterprise FQDN"
  default     = "https://app.terraform.io"
}

variable "aap_host" {
  description = "AAP host to connect the provider to"
  type        = string
}

variable "aap_username" {
  description = "AAP host username to connect the provider to"
  type        = string
}

variable "aap_password" {
  description = "AAP host password to connect the provider to"
  type        = string
}

variable "aap_inventory_name" {
  description = "AAP inventory name that contains the host"
  type        = string
  default     = "demo"
}

variable "allowed_ip" {
  description = "Allowed IP Address to SSH to the EC2 instance. Set this to the AAP IP"
  type        = string
  default     = "0.0.0.0/0"
}

variable "var_from_tf_aap_job_launch" {
  description = "Variable passed from Terraform to AAP via aap_job_launch action"
  type        = string
  default     = "hello from Terraform"
}
