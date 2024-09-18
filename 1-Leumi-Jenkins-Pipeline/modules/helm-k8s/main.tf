# path: Leumi-Jenkins-Pipeline/modules/helm-k8s/main.tf

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = module.eks.cluster_auth_token
  }
}

resource "helm_release" "python_app" {
  name       = var.helm_release_name
  repository = var.helm_repo_url
  chart      = var.helm_chart_name
  namespace  = var.helm_namespace

  # Pass values dynamically from Terraform variables (terraform.tfvars)
  set {
    name  = "global.ecr_repo"
    value = var.ecr_repo
  }

  set {
    name  = "global.service_type"
    value = var.service_type
  }

  set {
    name  = "global.domain_name"
    value = var.domain_name
  }

  set {
    name  = "global.tls_secret_name"
    value = var.tls_secret_name
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "service.port"
    value = var.service_port
  }

  set {
    name  = "global.replicas"
    value = var.replicas
  }

  values = [
    file("${path.module}/charts/python-app/values.yaml")
  ]

  depends_on = [module.eks]
}
