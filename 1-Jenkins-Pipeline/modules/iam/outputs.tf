# Outputs for EKS Control Plane Role ARN
output "eks_control_plane_role_arn" {
  value = data.aws_iam_role.eks_control_plane_role.arn
}

# Outputs for EKS Worker Node Role ARN
output "eks_worker_node_role_arn" {
  value = data.aws_iam_role.eks_worker_node_role.arn
}

# Outputs for Jenkins Role ARN
output "jenkins_role_arn" {
  value = data.aws_iam_role.jenkins_role.arn
}

# Outputs for Jenkins S3 Access Policy ARN
output "jenkins_s3_access_policy_arn" {
  value = data.aws_iam_policy.jenkins_s3_access_policy.arn
}

# Outputs for Jenkins instance profile
output "jenkins_instance_profile" {
  value = aws_iam_instance_profile.jenkins_instance_profile.arn
}

# Outputs for Jenkins instance profile ARN and name
output "jenkins_instance_profile_arn" {
  value = aws_iam_instance_profile.jenkins_instance_profile.arn
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_instance_profile.name
}
