terraform {
  source = "../../../modules//ec2"  # Path to the EC2 module

  extra_arguments "custom_tfvars" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = ["-var-file=/home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/terraform.tfvars"]
  }
}

include {
  path = find_in_parent_folders()
}

# Dependencies
dependency "vpc" {
  config_path = "../vpc"
}

dependency "iam" {
  config_path = "../iam"
}

inputs = {
  # Use outputs from the VPC and IAM dependencies
  vpc_id                     = dependency.vpc.outputs.vpc_id
  subnet_id                  = dependency.vpc.outputs.private_subnets[0]

  # Pass IAM instance profile and ARN
  instance_profile           = dependency.iam.outputs.jenkins_instance_profile_name
  jenkins_instance_profile_arn = dependency.iam.outputs.jenkins_instance_profile_arn

  # EC2-specific inputs
  ami_id        = "ami-05134c8ef96964280"  # Provided manually for now
  instance_type = "t2.medium"
  key_pair      = "jenkins-key-pair"  # Dynamically created key pair from the EC2 module
}
