# VPC Outputs

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_lock_table.name
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
