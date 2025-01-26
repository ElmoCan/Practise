# Outputs: Display important information after applying
output "public_ip" {
  value = aws_instance.minikube.public_ip
  description = "The public IP address of the EC2 instance"
}

output "private_ip" {
  value = aws_instance.minikube.private_ip
  description = "The private IP address of the EC2 instance"
}
