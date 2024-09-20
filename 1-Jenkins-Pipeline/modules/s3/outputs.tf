# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/s3/outputs.tf

# Output the Jenkins bucket name, only if it's created
output "jenkins_s3_bucket_name" {
  description = "Name of the S3 bucket used for Jenkins backups, artifacts, and logs"
  value       = length(aws_s3_bucket.jenkins) > 0 ? aws_s3_bucket.jenkins[0].bucket : data.aws_s3_bucket.jenkins_existing.bucket
}

output "jenkins_backups_folder" {
  description = "S3 path for Jenkins backups"
  value       = length(aws_s3_bucket.jenkins) > 0 ? "s3://${aws_s3_bucket.jenkins[0].bucket}/backups/" : "s3://${data.aws_s3_bucket.jenkins_existing.bucket}/backups/"
}

output "jenkins_artifacts_folder" {
  description = "S3 path for Jenkins artifacts"
  value       = length(aws_s3_bucket.jenkins) > 0 ? "s3://${aws_s3_bucket.jenkins[0].bucket}/artifacts/" : "s3://${data.aws_s3_bucket.jenkins_existing.bucket}/artifacts/"
}

output "jenkins_logs_folder" {
  description = "S3 path for Jenkins logs"
  value       = length(aws_s3_bucket.jenkins) > 0 ? "s3://${aws_s3_bucket.jenkins[0].bucket}/logs/" : "s3://${data.aws_s3_bucket.jenkins_existing.bucket}/logs/"
}

# Output the Terraform state bucket name, only if it's created
output "terraform_state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform state"
  value       = length(aws_s3_bucket.terraform_state) > 0 ? aws_s3_bucket.terraform_state[0].bucket : data.aws_s3_bucket.terraform_state_existing.bucket
}
