terraform {
  source = "../../../modules//ingress"
}

include {
  path = find_in_parent_folders()
}
