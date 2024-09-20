terraform {
  source = "../../../modules//monitoring"
}

include {
  path = find_in_parent_folders()
}
