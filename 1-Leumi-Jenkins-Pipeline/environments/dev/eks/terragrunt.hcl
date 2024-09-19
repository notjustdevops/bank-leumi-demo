# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/eks/terragrunt.hcl

terraform {
  source = "../../../modules//eks"  # Correct module path with double slashes
}

inputs = {
  aws_region      = local.aws_region
  cluster_name    = var.cluster_name
  common_tags     = local.common_tags
  node_instance_type = var.node_instance_type
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/eks/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

# Dependencies
dependency "vpc" {
  config_path = "../vpc"
}

dependency "iam" {
  config_path = "../iam"
}

locals {
  aws_region = "us-west-2"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}
