# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/vpc/terragrunt.hcl

terraform {
  source = "../../../modules//vpc"  # Ensure the correct path to the module
}

inputs = {
  aws_region         = local.aws_region
  vpc_cidr           = local.vpc_cidr
  public_subnet_cidr = local.public_subnet_cidr
  private_subnet_cidr = local.private_subnet_cidr
  common_tags        = local.common_tags
}

locals {
  aws_region         = "us-west-2"
  s3_bucket          = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"  # Correctly defined S3 bucket
  dynamodb_table_for_locks = "dvorkinguy-leumi-jenkins-locks"
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
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
    key            = "${local.resource_name_prefix}/vpc/terraform.tfstate"  # Ensure proper key path
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}
