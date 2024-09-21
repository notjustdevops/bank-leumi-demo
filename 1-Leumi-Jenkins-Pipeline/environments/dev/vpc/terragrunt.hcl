# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/vpc/terragrunt.hcl

terraform {
  source = "../../../modules//vpc"  # Correct module path
}

inputs = {
  resource_name_prefix = local.resource_name_prefix
  vpc_cidr             = local.vpc_cidr
  public_subnet_cidr   = local.public_subnet_cidr
  private_subnet_cidr  = local.private_subnet_cidr
  common_tags          = local.common_tags
}

locals {
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
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
    bucket         = "dvorkinguy-leumi-jenkins-dev-terraform-state-bucket"
    key            = "${local.resource_name_prefix}/vpc/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "dvorkinguy-leumi-jenkins-terraform-locks"
  }
}


