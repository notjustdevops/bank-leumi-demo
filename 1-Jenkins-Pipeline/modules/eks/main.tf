# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/eks/main.tf

provider "aws" {
  region = var.aws_region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach EKS Cluster Policy to the Role
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the Node Group Role
resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# Security Group for EKS Cluster Control Plane
resource "aws_security_group" "cluster" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.cluster_name}-sg"
    },
    var.common_tags
  )
}

# Security Group for Worker Nodes
resource "aws_security_group" "worker" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.cluster_name}-worker-sg"
    },
    var.common_tags
  )
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.this.arn

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.cluster.id]  # Attach security group to control plane
  }

  version = var.cluster_version

  depends_on = [
    aws_iam_role_policy_attachment.cluster_encryption,
    aws_security_group.cluster,
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.node_desired_capacity
    max_size     = var.node_max_capacity
    min_size     = var.node_min_capacity
  }

  instance_types = [var.eks_instance_type]
  ami_type       = "AL2_x86_64"

  depends_on = [aws_eks_cluster.this]
}

# Apply aws-auth ConfigMap
resource "null_resource" "apply_aws_auth" {
  provisioner "local-exec" {
    # Use the variable to locate the update-aws-auth.yaml file
    command = "kubectl apply -f ${var.aws_auth_config_path}"
  }

  depends_on = [aws_eks_cluster.this, aws_iam_role.this]
}
