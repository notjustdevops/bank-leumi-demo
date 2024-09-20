# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/modules/eks/main.tf

provider "aws" {
  region = var.aws_region
}

# IAM role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "${var.resource_name_prefix}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-eks-role" })
}

# Attach EKS Managed Policies to IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}

# Security group for EKS cluster
resource "aws_security_group" "eks_sg" {
  vpc_id = var.vpc_id

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

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-eks-sg" })
}

# EKS Cluster definition
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.resource_name_prefix}-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-eks-cluster" })

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy, aws_iam_role_policy_attachment.eks_service_policy]
}

