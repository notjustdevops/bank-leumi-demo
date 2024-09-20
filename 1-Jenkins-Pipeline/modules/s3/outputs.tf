# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/s3/outputs.tf

# Output the Jenkins bucket name
output "jenkins_s3_bucket_name" {
  description = "Name of the S3 bucket used for Jenkins"
  value       = aws_s3_bucket.jenkins.bucket
}

# Output the Terraform state bucket name
output "terraform_state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}
