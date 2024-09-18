# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/terragrunt.hcl

include {
  path = find_in_parent_folders()  # Inherit from the root terragrunt.hcl
}

inputs = {
  # Optionally override or add dev-specific inputs
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  instance_type      = var.instance_type

  # Helm and ECR
  helm_release_name  = var.helm_release_name
  image_tag          = var.image_tag

  # Dev-specific values can be added here if needed
}
