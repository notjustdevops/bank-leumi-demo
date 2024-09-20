# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/s3/main.tf

provider "aws" {
  region = var.aws_region
}

# Data source to check if the Jenkins bucket already exists
data "aws_s3_bucket" "jenkins_existing" {
  bucket = var.jenkins_bucket_name
}

# Jenkins bucket (create only if it doesn't already exist)
resource "aws_s3_bucket" "jenkins" {
  bucket = var.jenkins_bucket_name
  tags   = var.common_tags

  lifecycle {
    prevent_destroy = true  # Prevent accidental bucket destruction
  }

  depends_on = [data.aws_s3_bucket.jenkins_existing]
}

# Specify folders (prefixes) for backups, artifacts, and logs within the same Jenkins bucket
resource "aws_s3_bucket_object" "jenkins_backups_folder" {
  bucket = aws_s3_bucket.jenkins.bucket
  key    = "backups/"
}

resource "aws_s3_bucket_object" "jenkins_artifacts_folder" {
  bucket = aws_s3_bucket.jenkins.bucket
  key    = "artifacts/"
}

resource "aws_s3_bucket_object" "jenkins_logs_folder" {
  bucket = aws_s3_bucket.jenkins.bucket
  key    = "logs/"
}

# Terraform state bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.resource_name_prefix}-terraform-state"
  tags   = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}
