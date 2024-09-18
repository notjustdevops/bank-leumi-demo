# path: Leumi-Jenkins-Pipeline/modules/ecr/outputs.tf

output "ecr_repo_url" {
  value = aws_ecr_repository.python_app.repository_url
}

output "image_tag" {
  description = "The Docker image tag"
  value       = var.image_tag
}

output "ecr_repo_name" {
  value       = var.ecr_repo_name
  description = "ECR Repository Name"
}