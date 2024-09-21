# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/helm-k8s/terragrunt.hcl

terraform {
  source = "../../../modules//helm-k8s"  # Correct module path with double slashes
}

locals {
  ecr_repo_name = "${local.resource_name_prefix}-ecr-repo"  # Dynamic ECR repo name
}

inputs = {
  aws_region           = local.aws_region
  common_tags          = local.common_tags
  resource_name_prefix = local.resource_name_prefix

  # Python app-specific variables
  helm_release_name    = var.helm_release_name
  helm_repo_url        = var.helm_repo_url
  helm_chart_name      = var.helm_chart_name
  helm_namespace       = var.helm_namespace
  replicas             = var.replicas
  service_port         = var.service_port
  image_tag            = var.image_tag
  domain_name          = var.domain_name
  tls_secret_name      = var.tls_secret_name

  # ECR repository for the Python app
  ecr_repo             = local.ecr_repo_name  # Dynamically generated ECR repo name

  # Jenkins-specific variables
  jenkins_namespace    = var.jenkins_namespace
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/helm-k8s/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

# Dependencies (e.g., EKS, VPC)
dependency "eks" {
  config_path = "../eks"
}

dependency "vpc" {
  config_path = "../vpc"
}
