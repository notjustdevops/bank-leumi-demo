# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/iam/outputs.tf

# Outputs for EKS Control Plane Role ARN
output "eks_control_plane_role_arn" {
  value = length(aws_iam_role.eks_control_plane_role) > 0 ? aws_iam_role.eks_control_plane_role[0].arn : data.aws_iam_role.eks_control_plane_role.arn
}

# Outputs for EKS Worker Node Role ARN
output "eks_worker_node_role_arn" {
  value = length(aws_iam_role.eks_worker_node_role) > 0 ? aws_iam_role.eks_worker_node_role[0].arn : data.aws_iam_role.eks_worker_node_role.arn
}

# Outputs for Jenkins Role ARN
output "jenkins_role_arn" {
  value = length(aws_iam_role.jenkins_role) > 0 ? aws_iam_role.jenkins_role[0].arn : data.aws_iam_role.jenkins_role.arn
}

# Outputs for Jenkins S3 Access Policy ARN
output "jenkins_s3_access_policy_arn" {
  value = length(aws_iam_policy.jenkins_s3_access_policy) > 0 ? aws_iam_policy.jenkins_s3_access_policy[0].arn : data.aws_iam_policy.jenkins_s3_access_policy.arn
}
