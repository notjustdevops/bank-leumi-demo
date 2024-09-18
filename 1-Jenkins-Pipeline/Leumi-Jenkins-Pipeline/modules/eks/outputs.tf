# path: Leumi-Jenkins-Pipeline/modules/eks/outputs.tf

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_auth_token" {
  value = module.eks.token
}
