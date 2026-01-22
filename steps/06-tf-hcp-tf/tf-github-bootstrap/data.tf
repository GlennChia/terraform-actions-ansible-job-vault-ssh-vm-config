data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ec2_instance_type_offerings" "az" {
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  location_type = "availability-zone"
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_ami" "vault_ssh_ca_ec2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-vault-ssh-ca-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = [data.aws_caller_identity.current.account_id]
}
