terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.111.0"
    }
  }
}

provider "hcp" {
}