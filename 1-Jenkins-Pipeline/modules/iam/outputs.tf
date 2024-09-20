# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/iam/outputs.tf

output "eks_control_plane_role_arn" {
  description = "ARN of the EKS control plane IAM role"
  value       = aws_iam_role.eks_control_plane_role.arn
}

output "eks_worker_node_role_arn" {
  description = "ARN of the EKS worker node IAM role"
  value       = aws_iam_role.eks_worker_node_role.arn
}

output "jenkins_role_arn" {
  description = "ARN of the Jenkins IAM role"
  value       = aws_iam_role.jenkins_role.arn
}

output "jenkins_s3_access_policy_arn" {
  description = "ARN of the custom S3 access policy for Jenkins"
  value       = aws_iam_policy.jenkins_s3_access_policy.arn
}