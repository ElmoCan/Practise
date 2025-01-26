# Provider configuration: Specifies the cloud provider (AWS) and region
provider "aws" {
  region = "us-east-1" # Specify the AWS region
}

# Resource: AWS Security Group
resource "aws_security_group" "minikube_sg" {
  name        = "minikube-sg"
  description = "Allow SSH and Kubernetes ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow Kubernetes NodePort range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Resource: AWS EC2 Instance for Minikube
resource "aws_instance" "minikube" {
  ami           = "ami-04b4f1a9cf54c11d0" # Ubuntu AMI
  instance_type = "t2.medium"
  key_name      = "Terragrunt" # SSH key pair name

  # Root block device configuration for 30GB storage
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  # Associate security group with the default VPC
  vpc_security_group_ids = [aws_security_group.minikube_sg.id]

  # Reference the external user data file
  user_data = file("userdata.sh")

  tags = {
    Name = "Minikube-Server" # Tag for easy identification
  }
}

# Outputs: Display important information after applying
output "public_ip" {
  value = aws_instance.minikube.public_ip
  description = "The public IP address of the EC2 instance"
}

output "private_ip" {
  value = aws_instance.minikube.private_ip
  description = "The private IP address of the EC2 instance"
}
