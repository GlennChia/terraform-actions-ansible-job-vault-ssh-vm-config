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
  sensitive   = true
}

variable "aap_inventory_name" {
  description = "AAP inventory name that contains the host"
  type        = string
  default     = "demo"
}

variable "allowed_ip" {
  description = "allowed IP Address to SSH into the EC2 instance"
  type        = string
  default     = "0.0.0.0/0"
}

variable "region" {
  description = "Region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The instance type for the demo EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "tf_aap_resource_prefix" {
  description = "Prefix for TF AAP AWS resources created"
  type        = string
  default     = "tf-aap"
}
