variable "region" {
  description = "Region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "hvn_id" {
  description = "HVN ID - used as a prefix for HCP resources"
  type        = string
}

variable "vault_cluster_tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers - dev, standard_small, standard_medium, standard_large, plus_small, plus_medium, plus_large"
  type        = string
  default     = "standard_small"
}
