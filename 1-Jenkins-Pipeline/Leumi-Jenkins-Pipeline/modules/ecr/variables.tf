# path: Leumi-Jenkins-Pipeline/modules/ecr/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
}

variable "aws_region" {
  description = "AWS region for ECR"
  type        = string
}
