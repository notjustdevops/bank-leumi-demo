terraform {
  source = "../../../modules//secrets_manager"
}

include {
  path = find_in_parent_folders()
}
