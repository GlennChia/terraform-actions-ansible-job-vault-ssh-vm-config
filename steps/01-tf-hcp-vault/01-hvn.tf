resource "hcp_hvn" "this" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = "10.10.0.0/16"
}
