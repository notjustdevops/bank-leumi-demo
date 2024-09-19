# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/dynamodb/terragrunt.hcl

terraform {
  source = "../../../modules//dynamodb"  # Correct module path with double slashes
}

inputs = {
  aws_region        = local.aws_region
  common_tags       = local.common_tags
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket  # Updated the variable reference
    key            = "${local.resource_name_prefix}/dynamodb/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks  # Reference to the manually created table
  }
}

locals {
  aws_region           = "us-west-2"
  s3_bucket            = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"  # Defined the S3 bucket variable here
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"  # Dynamodb lock table reference
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}
