# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/eks/variables.tf

variable "aws_region" {
  description = "The AWS region where the EKS cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.24"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
}

variable "node_max_capacity" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "node_min_capacity" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "eks_instance_type" {
  description = "The instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "aws_auth_config_path" {
  description = "The file path for the aws-auth config map"
  type        = string
}
