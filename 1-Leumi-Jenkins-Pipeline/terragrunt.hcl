# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/terragrunt.hcl

inputs = {
  resource_name_prefix = var.resource_name_prefix
  aws_region           = var.aws_region
  common_tags          = var.common_tags

  # VPC and EC2 related inputs
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  instance_type      = var.instance_type

  # ECR and Helm configuration
  ecr_repo_name    = var.ecr_repo_name
  helm_release_name = var.helm_release_name
  helm_namespace    = var.helm_namespace
  image_tag         = var.image_tag
  service_port      = var.service_port

  # Jenkins specific variables
  jenkins_admin_password = var.jenkins_admin_password
}

# Optional: Remote state configuration (global, if needed)
remote_state {
  backend = "s3"

  config = {
    bucket         = "${var.s3_bucket_for_state}"
    key            = "${var.resource_name_prefix}/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = "${var.dynamodb_table_for_locks}"
  }
}
