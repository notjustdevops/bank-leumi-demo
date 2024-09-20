terraform {
  source = "../../../modules//acm"
}

include {
  path = find_in_parent_folders()
}
