terraform {
  source = "../../../modules//jenkins"
}

include {
  path = find_in_parent_folders()
}
