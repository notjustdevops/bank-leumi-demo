# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/security/terragrunt.hcl

terraform {
  source = "../../../modules//security"
}

inputs = {
  aws_region           = local.aws_region
  common_tags          = local.common_tags
  resource_name_prefix = local.resource_name_prefix

  # Capture the vpc_id from the VPC module
  vpc_id               = dependency.vpc.outputs.vpc_id
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/security/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

locals {
  s3_bucket_for_state      = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"
  resource_name_prefix     = "dvorkinguy-leumi-jenkins"
  aws_region               = "us-west-2"
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}

# Dependencies (e.g., VPC, IAM)
dependency "vpc" {
  config_path = "../vpc"
}

dependency "iam" {
  config_path = "../iam"
  skip_outputs = true
}
