# path: Leumi-Jenkins-Pipeline/modules/dynamodb/outputs.tf

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
