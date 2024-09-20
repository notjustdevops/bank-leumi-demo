terraform {
  source = "../../../modules//eks"
}

include {
  path = find_in_parent_folders()
}

# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/eks/terraform.tfvars

