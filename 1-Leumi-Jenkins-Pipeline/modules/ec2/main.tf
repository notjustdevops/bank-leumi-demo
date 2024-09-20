# path: Leumi-Jenkins-Pipeline/modules/ec2/main.tf

terraform {
  backend "s3" {}
}

# Fetch the latest Ubuntu AMI for the region
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Example for Ubuntu 20.04
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]  # Canonical's AWS account ID for Ubuntu
}

# Dynamically create an EC2 key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.resource_name_prefix}-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Optionally, store the private key locally or in Secrets Manager
resource "local_file" "ec2_private_key" {
  filename = "${path.module}/private-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the private key
  }
}

# Or store the private key in Secrets Manager (optional)
resource "aws_secretsmanager_secret" "ec2_private_key_secret" {
  name        = "${var.resource_name_prefix}-ec2-key-private"
  description = "EC2 key pair private key"

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-ec2-key-private" })
}

resource "aws_secretsmanager_secret_version" "ec2_private_key_secret_value" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key_secret.id
  secret_string = tls_private_key.ec2_key.private_key_pem

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the secret
  }
}

# EC2 instance using the dynamically created key pair
resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id  # Use your existing AMI data source
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key.key_name  # Dynamically generated key pair

  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.public_subnet_id

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-jenkins-server" })
}
