# path: Leumi-Jenkins-Pipeline/modules/helm-k8s/outputs.tf

output "helm_release_status" {
  description = "The status of the Helm release"
  value       = helm_release.python_app.status
}

output "helm_release_name" {
  description = "The name of the Helm release"
  value       = helm_release.python_app.name
}

output "service_name" {
  description = "The Kubernetes service name for the Python app"
  value       = helm_release.python_app.service[0].name
}
