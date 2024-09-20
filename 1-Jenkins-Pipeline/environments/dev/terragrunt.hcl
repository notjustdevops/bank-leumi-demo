terraform {
  source = "path_to_your_root_module"
}

inputs = {
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  aws_region           = "us-west-2"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Version     = "0.0.2"
  }
}
