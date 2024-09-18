# NLB Module Variables

variable "subnet_id" {
  description = "The subnet ID for the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the target group"
  type        = string
}

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
