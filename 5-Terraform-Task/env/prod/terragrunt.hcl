# terragrunt.hcl (prod environment)

dependency "vpc" {
  config_path = "../vpc"
}

dependency "latest_ami" {
  config_path = "../ec2"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  subnet_id             = dependency.vpc.outputs.subnet_id
  ami                   = dependency.latest_ami.outputs.ami_id
  common_tags           = merge(dependency.common.outputs.common_tags, { Env = "Prod" })
  resource_name_prefix  = "dvorkinguy-leumi-demo"
}
