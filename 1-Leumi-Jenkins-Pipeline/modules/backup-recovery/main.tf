# path: Leumi-Jenkins-Pipeline/modules/backup-recovery/main.tf

resource "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.resource_name_prefix}-backup"

  # Enable versioning for backups
  versioning {
    enabled = true
  }

  # Enable server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Apply lifecycle rules to move old backups to Glacier
  lifecycle_rule {
    id      = "move-old-backups-to-glacier"
    enabled = true

    # Transition objects to Glacier after 30 days
    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    # Expire objects after 365 days
    expiration {
      days = 365
    }
  }

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-backup" })
}

resource "aws_s3_bucket_policy" "backup_bucket_policy" {
  bucket = aws_s3_bucket.backup_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.backup_bucket.arn}/*"
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}
