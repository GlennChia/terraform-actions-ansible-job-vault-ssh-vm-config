output "public_ip" {
  description = "The public IP of the tf_aap EC2 instance"
  value       = aws_instance.tf_aap.public_ip
}

output "public_url" {
  description = "The public URL of the tf_aap EC2 instance"
  value       = "http://${aws_instance.tf_aap.public_ip}"
}