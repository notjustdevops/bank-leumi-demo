# path: Leumi-Jenkins-Pipeline/modules/ec2/variables.tf

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
}

variable "key_name" {
  description = "SSH key name for Jenkins server"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the instance"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for the Jenkins server"
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

variable "aws_region" {
  description = "AWS region for EC2"
  type        = string
}

