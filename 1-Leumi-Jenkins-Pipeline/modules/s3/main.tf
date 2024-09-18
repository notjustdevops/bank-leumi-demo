# path: Leumi-Jenkins-Pipeline/modules/s3/main.tf

resource "aws_s3_bucket" "dev_bucket" {
  bucket = "${var.resource_name_prefix}-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
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
