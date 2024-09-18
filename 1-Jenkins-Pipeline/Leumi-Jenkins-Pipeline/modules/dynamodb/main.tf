# path: Leumi-Jenkins-Pipeline/modules/dynamodb/main.tf

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.resource_name_prefix}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-dynamodb" })
}
