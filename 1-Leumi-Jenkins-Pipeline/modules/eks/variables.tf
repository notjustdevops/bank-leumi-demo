# path: Leumi-Jenkins-Pipeline/modules/eks/variables.tf

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the EKS cluster"
  type        = list(string)
}

variable "worker_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key name for EKS worker nodes"
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
