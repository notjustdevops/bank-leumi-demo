# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/ec2/terragrunt.hcl

terraform {
  source = "../../../modules/ec2"
}

inputs = {
  aws_region           = local.aws_region
  common_tags          = local.common_tags
  resource_name_prefix = local.resource_name_prefix

  # EC2-specific inputs
  instance_type        = "t2.micro"  # Replace with desired instance type
  security_group_id    = dependency.vpc.outputs.security_group_id
  public_subnet_id     = dependency.vpc.outputs.public_subnet_id
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.s3_bucket_for_state
    key            = "${local.resource_name_prefix}/ec2/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = local.dynamodb_table_for_locks
  }
}

# Dependencies (e.g., VPC)
dependency "vpc" {
  config_path = "../vpc"
}
