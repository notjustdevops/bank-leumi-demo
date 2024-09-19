# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/monitoring/terragrunt.hcl

terraform {
  source = "../../../modules//monitoring"  # Correct module path
}

inputs = {
  aws_region           = local.aws_region
  common_tags          = local.common_tags
  resource_name_prefix = local.resource_name_prefix
  notification_email   = var.notification_email
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/monitoring/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

# Dependencies (e.g., VPC, EC2, EKS)
dependency "vpc" {
  config_path = "../vpc"
  skip_outputs = true
}

dependency "ec2" {
  config_path = "../ec2"
}

dependency "eks" {
  config_path = "../eks"
}
