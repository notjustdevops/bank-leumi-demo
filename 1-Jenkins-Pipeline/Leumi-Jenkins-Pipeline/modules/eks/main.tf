# path: Leumi-Jenkins-Pipeline/modules/eks/main.tf

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.resource_name_prefix}-eks-cluster"
  cluster_version = "1.22"  # Kubernetes version
  subnets         = var.subnet_ids
  vpc_id          = var.vpc_id

  worker_groups = [
    {
      instance_type = var.worker_instance_type
      key_name      = var.key_name
    }
  ]

  tags = var.common_tags
}
