# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/terragrunt.hcl

# Common settings for the dev environment
inputs = {
  aws_region           = "us-west-2"
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
}
