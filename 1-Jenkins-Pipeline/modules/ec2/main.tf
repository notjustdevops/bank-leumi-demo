provider "aws" {
  region = var.aws_region
}

# Automatically Create an SSH Key Pair if it doesn't exist
resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.key_pair
  public_key = file(var.ssh_public_key_path)
}

# EC2 Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "${var.resource_name_prefix}-jenkins-sg"
  description = "Allow SSH and HTTPS traffic for Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

# Dynamic AMI ID Retrieval for Ubuntu 20.04 in the specified region
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance for Jenkins
resource "aws_instance" "jenkins_instance" {
  ami                  = data.aws_ami.ubuntu_ami.id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  key_name             = aws_key_pair.jenkins_key_pair.key_name
  iam_instance_profile = var.instance_profile

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y openjdk-11-jre
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  EOF

  tags = {
    Name = "jenkins-instance"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}
