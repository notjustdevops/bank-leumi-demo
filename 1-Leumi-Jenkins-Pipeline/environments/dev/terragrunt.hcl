# /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/terragrunt.hcl

remote_state {
  backend = "s3"
  config = {
    bucket         = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"
    key            = "${local.resource_name_prefix}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "dvorkinguy-leumi-jenkins-locks"
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

inputs = {
  aws_region          = local.aws_region
  common_tags         = local.common_tags
  resource_name_prefix = local.resource_name_prefix
}

# Dependency for VPC module
dependency "vpc" {
  config_path = "./vpc"
  skip_outputs = true  # Skip outputs as the VPC module has no outputs
}

# Dependency for DynamoDB module
dependency "dynamodb" {
  config_path = "./dynamodb"
  skip_outputs = true  # Skip outputs as the DynamoDB module has no outputs or was created manually
}

# Dependency for S3 module
dependency "s3" {
  config_path = "./s3"
  skip_outputs = true  # Skip outputs as the S3 module has no outputs or was created manually
}

dependency "ec2" {
  config_path = "./ec2"
  skip_outputs = true  # Skip outputs since the ec2 module may not have outputs
}

# Dependency for ECR module
dependency "ecr" {
  config_path = "./ecr"
  skip_outputs = true  # Skip outputs as the ECR module has no outputs
}

# Dependency for EKS module
dependency "eks" {
  config_path = "./eks"
  skip_outputs = true
}

# Dependency for Jenkins module
dependency "jenkins" {
  config_path = "./jenkins"
  skip_outputs = true
}

# Dependency for Backup and Recovery module
dependency "backup_recovery" {
  config_path = "./backup-recovery"
  skip_outputs = true  # Skip outputs as this module doesn't have outputs or was created manually
}

# Dependency for Helm-K8S module
dependency "helm_k8s" {
  config_path = "./helm-k8s"
  skip_outputs = true
}

dependency "iam" {
  config_path = "./iam"
  skip_outputs = true
}

# Dependency for Logging module
dependency "logging" {
  config_path = "./logging"
  skip_outputs = true
}

# Dependency for Monitoring module
dependency "monitoring" {
  config_path = "./monitoring"
  skip_outputs = true
}

dependency "security" {
  config_path = "./security"
  skip_outputs = true  # Skip outputs as the security module has no outputs
}

