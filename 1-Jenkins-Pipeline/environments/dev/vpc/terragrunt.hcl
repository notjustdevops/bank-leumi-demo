# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/vpc/terragrunt.hcl

terraform {
  source = "../../../modules//vpc"
  
  extra_arguments "custom_tfvars" {
    commands = get_terraform_commands_that_need_vars()

    # Use the absolute path to the terraform.tfvars file
    arguments = ["-var-file=/home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/terraform.tfvars"]
  }
}

# Optionally, inherit common settings (if you have a parent terragrunt.hcl)
include {
  path = find_in_parent_folders()
}
