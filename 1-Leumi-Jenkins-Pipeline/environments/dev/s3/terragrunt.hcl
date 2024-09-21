# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/s3/terragrunt.hcl

terraform {
  source = "../../../modules//s3"  # Correct module path
}

inputs = {
  aws_region           = local.aws_region
  bucket_name          = local.s3_bucket_name  # Pass bucket name from locals
  versioning_enabled   = true                  # Pass versioning dynamically
  resource_name_prefix = local.resource_name_prefix  # Dynamically set resource name prefix
  common_tags          = local.common_tags
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"  # Replace with actual S3 bucket name
    key            = "${local.resource_name_prefix}/s3/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

locals {
  aws_region             = "us-west-2"
  resource_name_prefix   = "dvorkinguy-leumi-jenkins"  # Dynamically set resource name prefix here
  s3_bucket_name         = "dvorkinguy-leumi-jenkins-s3-bucket"
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"
  
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }
}
