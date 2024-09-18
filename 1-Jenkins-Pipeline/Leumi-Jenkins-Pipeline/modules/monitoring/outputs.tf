# path: Leumi-Jenkins-Pipeline/modules/monitoring/outputs.tf

output "cpu_alarm_arn" {
  description = "The ARN of the CloudWatch CPU alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization_high.arn
}

output "memory_alarm_arn" {
  description = "The ARN of the CloudWatch memory alarm"
  value       = aws_cloudwatch_metric_alarm.memory_utilization_high.arn
}

# path: Leumi-Jenkins-Pipeline/modules/monitoring/outputs.tf

output "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarm notifications"
  value       = aws_sns_topic.alarm_notifications.arn
}
