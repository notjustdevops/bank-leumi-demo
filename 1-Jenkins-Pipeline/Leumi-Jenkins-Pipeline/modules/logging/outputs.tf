# path: Leumi-Jenkins-Pipeline/modules/logging/outputs.tf

output "jenkins_log_group_arn" {
  description = "The ARN of the CloudWatch log group for Jenkins"
  value       = aws_cloudwatch_log_group.jenkins_log_group.arn
}
