# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/dynamodb/main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "${var.resource_name_prefix}-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.common_tags
}


