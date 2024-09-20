# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/vpc/outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "Private subnets"
  value       = aws_subnet.private[*].id
}