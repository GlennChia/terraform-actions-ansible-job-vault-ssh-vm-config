resource "aws_iam_openid_connect_provider" "hcp_terraform" {
  url = var.terraform_url

  client_id_list = [
    "aws.workload.identity",
  ]
}

data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcp_terraform.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.terraform_fqdn_no_protocol}:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "${local.terraform_fqdn_no_protocol}:sub"
      values   = ["organization:${var.tf_organization_name}:project:${tfe_project.this.name}:workspace:${local.workspace_name}:run_phase:*"]
    }
  }
}

resource "aws_iam_role" "tf_workspace" {
  name_prefix        = "tf-oidc-demo"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "tf_workspace_administrator_access" {
  policy_arn = data.aws_iam_policy.administrator_access.arn
  role       = aws_iam_role.tf_workspace.name
}
