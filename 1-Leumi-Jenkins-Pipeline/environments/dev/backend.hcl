# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev/backend.hcl

remote_state {
  backend = "s3"

  config = {
    bucket         = "${var.s3_bucket_for_state}"  # Referencing from tfvars
    key            = "${var.resource_name_prefix}/terraform.tfstate"
    region         = "${var.aws_region}"
    encrypt        = true
    dynamodb_table = "${var.dynamodb_table_for_locks}"
  }
}
