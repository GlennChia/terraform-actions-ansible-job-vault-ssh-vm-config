locals {
  organization_name = "Default"
}

data "aap_inventory" "this" {
  name              = var.aap_inventory_name
  organization_name = local.organization_name
}

resource "aap_host" "this" {
  inventory_id = data.aap_inventory.this.id
  name         = "ec2-demo-host"
  description  = "EC2 instance with public IP ${aws_instance.tf_aap.public_ip}"

  variables = jsonencode({
    ansible_host = aws_instance.tf_aap.public_ip
  })

  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.aap_job_launch.this]
    }
  }
}

data "aap_job_template" "this" {
  name              = "demo-job-template"
  organization_name = local.organization_name
}

variable "var_from_tf_aap_job_launch" {
  description = "Variable to pass to the AAP Job and appears on the custom UI"
  type        = string
}

action "aap_job_launch" "this" {
  config {
    extra_vars          = jsonencode({ "var_from_tf_aap_job_launch" : var.var_from_tf_aap_job_launch })
    job_template_id     = data.aap_job_template.this.id
    wait_for_completion = true
  }
}
