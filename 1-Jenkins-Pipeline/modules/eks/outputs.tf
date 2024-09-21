# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/eks/outputs.tf

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "The name of the EKS cluster"
}

output "node_group_name" {
  value       = aws_eks_node_group.node_group.node_group_name
  description = "The name of the EKS node group"
}

output "cluster_security_group" {
  value       = aws_security_group.cluster.id
  description = "The security group ID for the EKS cluster"
}

output "worker_security_group" {
  value       = aws_security_group.worker.id
  description = "The security group ID for the worker nodes"
}

# Output security group IDs for use in security group rules
output "cluster_sg_id" {
  value = aws_security_group.cluster.id
}

output "worker_sg_id" {
  value = aws_security_group.worker.id
}
