# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/jenkins/terragrunt.hcl

terraform {
  source = "../../../modules//jenkins"  # Double slashes for module reference
}

inputs = {
  aws_region           = local.aws_region
  common_tags          = local.common_tags
  resource_name_prefix = local.resource_name_prefix
  jenkins_admin_password = var.jenkins_admin_password
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/jenkins/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

# Dependencies (e.g., VPC, Security Groups, IAM)
dependency "vpc" {
  config_path = "../vpc"
}

dependency "security" {
  config_path = "../security"
}

dependency "iam" {
  config_path = "../iam"
}
