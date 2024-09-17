# IAM Module Variables

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "env_tag" {
  description = "Environment tag"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}
