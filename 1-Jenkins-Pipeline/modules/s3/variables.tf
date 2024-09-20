# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/s3/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "jenkins_bucket_name" {
  description = "The name of the Jenkins S3 bucket"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
