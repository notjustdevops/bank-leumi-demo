# path: Leumi-Jenkins-Pipeline/modules/security/variables.tf

variable "vpc_id" {
  description = "VPC ID for the security group"
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
