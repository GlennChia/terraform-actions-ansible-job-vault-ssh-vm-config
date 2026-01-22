packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "al2023" {
  ami_name      = "${var.ami_name_prefix}-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.region

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*.*.0-kernel-6.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }

  ssh_username = "ec2-user"

  tags = {
    Name        = "${var.ami_name_prefix}-{{timestamp}}"
    BuildDate   = "{{timestamp}}"
    Description = "Amazon Linux 2023 with Vault SSH CA configured"
  }
}

build {
  sources = ["source.amazon-ebs.al2023"]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "sudo cloud-init status --wait",
      "echo 'Creating SSH trusted CA directory...'",
      "sudo mkdir -p /etc/ssh"
    ]
  }

  provisioner "file" {
    content     = var.vault_ssh_ca_public_key
    destination = "/tmp/trusted-user-ca-keys.pem"
  }

  provisioner "shell" {
    inline = [
      "echo 'Installing Vault SSH CA public key...'",
      "sudo mv /tmp/trusted-user-ca-keys.pem /etc/ssh/trusted-user-ca-keys.pem",
      "sudo chmod 644 /etc/ssh/trusted-user-ca-keys.pem",
      "echo 'Configuring SSHD to trust the CA...'",
      "sudo grep -q '^TrustedUserCAKeys' /etc/ssh/sshd_config || echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' | sudo tee -a /etc/ssh/sshd_config",
      "echo 'Validating SSHD configuration...'",
      "sudo sshd -t",
      "echo 'Restarting SSHD service...'",
      "sudo systemctl restart sshd",
      "echo 'Verifying SSHD is running...'",
      "sudo systemctl status sshd --no-pager"
    ]
  }
}
