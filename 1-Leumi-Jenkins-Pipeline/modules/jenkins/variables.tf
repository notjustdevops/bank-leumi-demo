# path: Leumi-Jenkins-Pipeline/modules/jenkins/variables.tf

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region for Jenkins"
  type        = string
}
