# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/iam/terragrunt.hcl

terraform {
  source = "../../../modules//iam"
}

inputs = {
  aws_region          = local.aws_region
  common_tags         = local.common_tags
  resource_name_prefix = local.resource_name_prefix
}

# Dependency for VPC module
dependency "vpc" {
  config_path = "../vpc"
  skip_outputs = true  # Skip outputs as the VPC module has no outputs
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

locals {
  aws_region               = "us-west-2"
  resource_name_prefix     = "dvorkinguy-leumi-jenkins"
  s3_bucket_for_state      = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}
