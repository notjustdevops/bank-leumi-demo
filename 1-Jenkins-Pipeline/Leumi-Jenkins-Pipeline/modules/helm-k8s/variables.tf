# path: Leumi-Jenkins-Pipeline/modules/helm-k8s/variables.tf

# Helm release-related variables
variable "helm_release_name" {
  description = "Name of the Helm release"
  type        = string
}

variable "helm_repo_url" {
  description = "URL of the Helm chart repository"
  type        = string
}

variable "helm_chart_name" {
  description = "Name of the Helm chart to be deployed"
  type        = string
}

variable "helm_namespace" {
  description = "Kubernetes namespace for Helm release"
  type        = string
}

# Docker image repository and tag
variable "ecr_repo" {
  description = "ECR repository for the Docker image"
  type        = string
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
}

# Kubernetes service-related variables
variable "service_type" {
  description = "Service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
}

variable "service_port" {
  description = "Port on which the service will be exposed"
  type        = number
}

# Ingress-related variables
variable "domain_name" {
  description = "Domain name for Ingress"
  type        = string
}

variable "tls_secret_name" {
  description = "TLS secret name for Ingress"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the Kubernetes deployment"
  type        = number
  default     = 2  # Default to 2 if not set in tfvars
}