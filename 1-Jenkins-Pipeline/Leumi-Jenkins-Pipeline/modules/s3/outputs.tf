# path: Leumi-Jenkins-Pipeline/modules/s3/outputs.tf

output "s3_bucket_name" {
  value = aws_s3_bucket.dev_bucket.bucket
}
