# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/ecr/terragrunt.hcl

terraform {
  source = "../../../modules//ecr"  # Ensure the correct path to the module
}

inputs = {
  aws_region         = local.aws_region
  ecr_repo_name      = local.ecr_repo_name
  common_tags        = local.common_tags
}

locals {
  aws_region         = "us-west-2"
  s3_bucket          = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"  # Correct S3 bucket definition
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  ecr_repo_name      = "${local.resource_name_prefix}-ecr-repo"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket  # Use the correct reference for the S3 bucket
    key            = "${local.resource_name_prefix}/ecr/terraform.tfstate"  # Ensure proper key path for ECR
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}
