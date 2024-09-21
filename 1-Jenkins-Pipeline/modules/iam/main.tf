provider "aws" {
  region = var.aws_region
}

# Fetch existing IAM roles and policies
data "aws_iam_role" "eks_control_plane_role" {
  name = "dvorkinguy-leumi-jenkins-eks-control-plane"
}

data "aws_iam_role" "eks_worker_node_role" {
  name = "dvorkinguy-leumi-jenkins-eks-worker-node"
}

data "aws_iam_role" "jenkins_role" {
  name = "dvorkinguy-leumi-jenkins-jenkins-role"
}

data "aws_iam_policy" "jenkins_s3_access_policy" {
  arn = "arn:aws:iam::${var.account_id}:policy/dvorkinguy-leumi-jenkins-s3-access-policy"
}

# EKS Control Plane Role
resource "aws_iam_role" "eks_control_plane_role" {
  count = length(data.aws_iam_role.eks_control_plane_role.id) == 0 ? 1 : 0
  name  = "${var.resource_name_prefix}-eks-control-plane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_control_plane_policy" {
  count = length(aws_iam_role.eks_control_plane_role) > 0 ? 1 : 0
  role  = aws_iam_role.eks_control_plane_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Worker Node Role
resource "aws_iam_role" "eks_worker_node_role" {
  count = length(data.aws_iam_role.eks_worker_node_role.id) == 0 ? 1 : 0
  name  = "${var.resource_name_prefix}-eks-worker-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  count = length(aws_iam_role.eks_worker_node_role) > 0 ? 1 : 0
  role  = aws_iam_role.eks_worker_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  count = length(aws_iam_role.eks_worker_node_role) > 0 ? 1 : 0
  role  = aws_iam_role.eks_worker_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  count = length(aws_iam_role.eks_worker_node_role) > 0 ? 1 : 0
  role  = aws_iam_role.eks_worker_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Jenkins IAM Role
resource "aws_iam_role" "jenkins_role" {
  count = length(data.aws_iam_role.jenkins_role.id) == 0 ? 1 : 0
  name  = "${var.resource_name_prefix}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "jenkins_s3_access_policy" {
  count = length(data.aws_iam_policy.jenkins_s3_access_policy.id) == 0 ? 1 : 0
  name        = "${var.resource_name_prefix}-s3-access-policy"
  description = "Allow Jenkins to access S3 for backups and logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject"
      ]
      Resource = [
        "arn:aws:s3:::${var.jenkins_bucket_name}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_s3_access_policy_attach" {
  count = length(aws_iam_role.jenkins_role) > 0 ? 1 : 0
  role  = aws_iam_role.jenkins_role[0].name
  policy_arn = aws_iam_policy.jenkins_s3_access_policy[0].arn
}
