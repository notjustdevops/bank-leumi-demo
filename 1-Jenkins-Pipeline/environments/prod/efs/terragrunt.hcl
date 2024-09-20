terraform {
  source = "../../../modules//efs"
}

include {
  path = find_in_parent_folders()
}
