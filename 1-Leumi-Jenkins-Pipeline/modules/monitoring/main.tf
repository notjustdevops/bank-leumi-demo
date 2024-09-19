# path: Leumi-Jenkins-Pipeline/modules/monitoring/main.tf

# Create an SNS topic for alarm notifications
terraform {
  backend "s3" {}
}


resource "aws_sns_topic" "alarm_notifications" {
  name = "${var.resource_name_prefix}-alarm-topic"
}

# Subscribe an email address to the SNS topic
resource "aws_sns_topic_subscription" "alarm_email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Create CloudWatch Alarm for EC2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "${var.resource_name_prefix}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high CPU utilization"
  dimensions = {
    InstanceId = var.jenkins_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-cpu-high-alarm" })
}

# Create CloudWatch Alarm for EC2 memory usage (requires CloudWatch agent)
resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  alarm_name          = "${var.resource_name_prefix}-memory-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors high memory utilization"
  dimensions = {
    InstanceId = var.jenkins_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-memory-high-alarm" })
}
