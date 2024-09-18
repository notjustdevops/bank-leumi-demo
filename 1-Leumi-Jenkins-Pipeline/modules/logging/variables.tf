# path: Leumi-Jenkins-Pipeline/modules/logging/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "jenkins_iam_role_arn" {
  description = "IAM role ARN for Jenkins to write logs"
  type        = string
}
