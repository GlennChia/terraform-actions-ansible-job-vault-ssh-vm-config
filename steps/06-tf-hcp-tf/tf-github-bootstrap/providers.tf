terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    aap = {
      source  = "ansible/aap"
      version = "~> 1.4"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aap" {
  host     = var.aap_host
  username = var.aap_username
  password = var.aap_password
}
