# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/environments/dev/s3/terragrunt.hcl

terraform {
  source = "../../../modules//s3"
}

inputs = {
  aws_region           = "us-west-2"
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  jenkins_bucket_name  = "dvorkinguy-leumi-jenkins-jenkins-bucket"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Version     = "0.0.2"
  }
}
