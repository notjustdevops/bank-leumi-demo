# Define tags and resource names centrally

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {
    Name      = "Bank-Leumi-Demo"
    Owner     = "Dvorkin Guy"
    Terraform = "True"
  }
}

variable "resource_name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "dvorkinguy-leumi-demo"
}

variable "env_tag" {
  description = "Environment-specific tag"
  type        = string
}
