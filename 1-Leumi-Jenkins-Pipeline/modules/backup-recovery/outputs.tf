# path: Leumi-Jenkins-Pipeline/modules/backup-recovery/outputs.tf

output "backup_bucket_name" {
  description = "The name of the backup S3 bucket"
  value       = aws_s3_bucket.backup_bucket.id
}

output "backup_bucket_arn" {
  description = "The ARN of the backup S3 bucket"
  value       = aws_s3_bucket.backup_bucket.arn
}
