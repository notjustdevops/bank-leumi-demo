# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/iam/terragrunt.hcl

terraform {
  source = "../../../modules//iam"
  
  extra_arguments "custom_tfvars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = ["-var-file=/home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/terraform.tfvars"]
  }
}

include {
  path = find_in_parent_folders()
}

# Dependencies on VPC and S3 modules
dependency "vpc" {
  config_path = "../vpc"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  vpc_id    = dependency.vpc.outputs.vpc_id
  s3_bucket = dependency.s3.outputs.jenkins_s3_bucket_name
}
