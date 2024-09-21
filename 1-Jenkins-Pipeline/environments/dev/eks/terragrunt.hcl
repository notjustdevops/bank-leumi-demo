terraform {
  source = "../../../modules//eks"
}

# VPC Dependency
dependency "vpc" {
  config_path = "../vpc"
}

# IAM Dependency
dependency "iam" {
  config_path = "../iam"
}

# EC2 Dependency
dependency "ec2" {
  config_path = "../ec2"
}

inputs = {
  # Retrieve values dynamically from dependencies
  aws_region        = "us-west-2"
  vpc_id            = dependency.vpc.outputs.vpc_id
  public_subnets    = dependency.vpc.outputs.public_subnets
  private_subnets   = dependency.vpc.outputs.private_subnets
  cluster_name      = "leumi-jenkins-dev-eks-cluster"
  cluster_version   = "1.24"
  node_group_name   = "leumi-jenkins-dev-node-group"
  node_desired_capacity = 2
  node_min_capacity     = 1
  node_max_capacity     = 3
  eks_instance_type     = "t3.medium"
  enable_logging      = true

  # Add common tags
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Version     = "0.0.2"
  }

  # IAM Role Outputs
  iam_role_arn         = dependency.iam.outputs.eks_control_plane_role_arn
  iam_node_role_arn    = dependency.iam.outputs.eks_worker_node_role_arn

  # Add the path to the aws-auth config file
  aws_auth_config_path = "${get_terragrunt_dir()}/update-aws-auth.yaml"
}
