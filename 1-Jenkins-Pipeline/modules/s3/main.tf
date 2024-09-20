# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/s3/main.tf

provider "aws" {
  region = var.aws_region
}

# Data source to check if the Jenkins bucket already exists
data "aws_s3_bucket" "jenkins_existing" {
  bucket = "${var.resource_name_prefix}-jenkins-bucket"
  # This will try to find the existing bucket. If it doesn't exist, proceed with creation
}

# Data source to check if the Terraform state bucket already exists
data "aws_s3_bucket" "terraform_state_existing" {
  bucket = "${var.resource_name_prefix}-terraform-state"
}

# Jenkins bucket with folders for backups, artifacts, and logs
resource "aws_s3_bucket" "jenkins" {
  count = length(data.aws_s3_bucket.jenkins_existing.id) == 0 ? 1 : 0  # Create only if the bucket doesn't exist

  bucket = "${var.resource_name_prefix}-jenkins-bucket"

  tags = var.common_tags

  lifecycle {
    prevent_destroy = true  # Prevent accidental bucket destruction
  }
}

# Specify folders (prefixes) for backups, artifacts, and logs within the same bucket
resource "aws_s3_bucket_object" "jenkins_backups_folder" {
  bucket = aws_s3_bucket.jenkins[count.index].bucket  # Use count.index to reference specific instance
  key    = "backups/"
  count  = length(data.aws_s3_bucket.jenkins_existing.id) == 0 ? 1 : 0  # Create only if the bucket was created
}

resource "aws_s3_bucket_object" "jenkins_artifacts_folder" {
  bucket = aws_s3_bucket.jenkins[count.index].bucket
  key    = "artifacts/"
  count  = length(data.aws_s3_bucket.jenkins_existing.id) == 0 ? 1 : 0
}

resource "aws_s3_bucket_object" "jenkins_logs_folder" {
  bucket = aws_s3_bucket.jenkins[count.index].bucket
  key    = "logs/"
  count  = length(data.aws_s3_bucket.jenkins_existing.id) == 0 ? 1 : 0
}

# Versioning resource for Jenkins bucket
resource "aws_s3_bucket_versioning" "jenkins_versioning" {
  bucket = aws_s3_bucket.jenkins[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
  count = length(data.aws_s3_bucket.jenkins_existing.id) == 0 ? 1 : 0
}

# Terraform state bucket (conditionally create)
resource "aws_s3_bucket" "terraform_state" {
  count = length(data.aws_s3_bucket.terraform_state_existing.id) == 0 ? 1 : 0

  bucket = "${var.resource_name_prefix}-terraform-state"

  tags = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
  count = length(data.aws_s3_bucket.terraform_state_existing.id) == 0 ? 1 : 0
}
