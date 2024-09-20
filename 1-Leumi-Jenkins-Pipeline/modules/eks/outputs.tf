# path: Leumi-Jenkins-Pipeline/modules/eks/outputs.tf

# Output EKS Cluster details
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_security_group_id" {
  value = aws_security_group.eks_sg.id
}
