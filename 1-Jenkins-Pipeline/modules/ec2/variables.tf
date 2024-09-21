# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/ec2/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy the EC2 instance in"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the Jenkins server"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "key_pair" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key file on your local machine"
  type        = string
}

variable "instance_profile" {
  description = "The IAM instance profile to attach to the EC2 instance"
  type        = string
  #default     = "arn:aws:iam::864492617736:instance-profile/dvorkinguy-leumi-jenkins-instance-profile"  # Hardcoded
}
