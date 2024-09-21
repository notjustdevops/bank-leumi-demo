# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/backup-recovery/terragrunt.hcl

terraform {
  source = "../../../modules//backup-recovery"
}

locals {
  aws_region = "us-west-2"
  resource_name_prefix = "dvorkinguy-leumi-jenkins"  # Add resource_name_prefix here
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Project     = "Leumi-Jenkins"
  }

  # Hard-code the S3 bucket name, as it was manually created
  s3_bucket_for_state = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"
}

inputs = {
  aws_region          = local.aws_region
  common_tags         = local.common_tags
  resource_name_prefix = local.resource_name_prefix  # Now passing the resource_name_prefix to inputs
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state  # Now correctly references the defined local variable
    key            = "${local.resource_name_prefix}/backup-recovery/terraform.tfstate"  # Fixed reference to resource_name_prefix
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "dvorkinguy-leumi-jenkins-locks"  # Reference directly, as it's static
  }
}

# S3 dependency block
dependency "s3" {
  config_path = "../s3"
  skip_outputs = true  # Skip outputs as the S3 module has no outputs or was created manually
}
