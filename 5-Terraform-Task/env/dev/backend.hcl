# backend.hcl (dev environment)

remote_state {
  backend = "s3"

  config = {
    bucket         = "dvorkinguy-leumi-demo-dev-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = dependency.vpc.outputs.dynamodb_table_name  # Use from dependency
  }
}
