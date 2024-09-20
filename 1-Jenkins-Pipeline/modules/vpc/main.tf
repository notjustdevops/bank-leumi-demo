# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/vpc/main.tf

provider "aws" {
  region = var.aws_region
}

# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge({
    Name = "${var.resource_name_prefix}-vpc"
  }, var.common_tags)
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.resource_name_prefix}-public-subnet-${count.index + 1}"
  }, var.common_tags)
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = merge({
    Name = "${var.resource_name_prefix}-private-subnet-${count.index + 1}"
  }, var.common_tags)
}

# Create Security Group for Jenkins and EKS
resource "aws_security_group" "jenkins_eks" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.resource_name_prefix}-security-group"
  }, var.common_tags)
}

data "aws_availability_zones" "available" {}
