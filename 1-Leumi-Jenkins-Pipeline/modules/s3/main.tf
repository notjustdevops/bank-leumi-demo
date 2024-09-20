# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/modules/s3/main.tf

terraform {
  backend "s3" {}  # Define an empty backend block
}

resource "aws_s3_bucket" "dev_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-s3" })
}
