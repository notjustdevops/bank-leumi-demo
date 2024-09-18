# path: Leumi-Jenkins-Pipeline/modules/monitoring/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "jenkins_instance_id" {
  description = "Instance ID of the Jenkins EC2 server"
  type        = string
}

variable "alarm_action_arn" {
  description = "ARN of the action to take when the alarm is triggered (e.g., SNS topic)"
  type        = string
}

variable "notification_email" {
  description = "Email address for alarm notifications"
  type        = string
}

