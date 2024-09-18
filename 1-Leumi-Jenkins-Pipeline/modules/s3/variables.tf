# path: Leumi-Jenkins-Pipeline/modules/s3/variables.tf

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
