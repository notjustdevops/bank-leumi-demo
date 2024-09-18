# path: Leumi-Jenkins-Pipeline/modules/iam/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "s3_backup_arn" {
  description = "ARN of the S3 bucket for backups"
  type        = string
}

variable "jenkins_admin_password" {
  description = "The Jenkins admin password"
  type        = string
  sensitive   = true  # Mark this as sensitive to prevent it from being logged
}
