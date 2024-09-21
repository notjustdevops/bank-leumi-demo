# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/iam/variables.tf

variable "aws_region" {
  description = "AWS region where the infrastructure is deployed"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for naming all AWS resources"
  type        = string
}

variable "jenkins_bucket_name" {
  description = "Name of the S3 bucket used by Jenkins for backups, artifacts, and logs"
  type        = string
}

variable "jenkins_instance_profile" {
  description = "The name of the Jenkins EC2 instance profile"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "account_id" {
  description = "Account ID"
  type        = string
}
