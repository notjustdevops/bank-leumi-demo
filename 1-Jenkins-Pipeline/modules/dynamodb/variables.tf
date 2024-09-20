# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/dynamodb/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
