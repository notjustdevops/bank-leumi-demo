# backend.hcl (prod environment)

remote_state {
  backend = "s3"

  config = {
    bucket         = "dvorkinguy-leumi-demo-prod-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = dependency.vpc.outputs.dynamodb_table_name
  }
}
