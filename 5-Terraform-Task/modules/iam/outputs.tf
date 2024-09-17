# IAM Module Outputs
# IAM Module Outputs

output "iam_role" {
  description = "The name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
