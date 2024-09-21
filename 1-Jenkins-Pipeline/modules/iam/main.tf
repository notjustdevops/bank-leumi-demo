provider "aws" {
  region = var.aws_region
}

# Fetch existing IAM policy for Jenkins
data "aws_iam_policy" "jenkins_s3_access_policy" {
  arn = "arn:aws:iam::${var.account_id}:policy/dvorkinguy-leumi-jenkins-s3-access-policy"
}

# Fetch existing EKS Control Plane Role
data "aws_iam_role" "eks_control_plane_role" {
  name = "${var.resource_name_prefix}-eks-control-plane"
}

# Fetch existing EKS Worker Node Role
data "aws_iam_role" "eks_worker_node_role" {
  name = "${var.resource_name_prefix}-eks-worker-node"
}

# Fetch existing Jenkins Role
data "aws_iam_role" "jenkins_role" {
  name = "${var.resource_name_prefix}-jenkins-role"
}

# Jenkins IAM Instance Profile
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.resource_name_prefix}-jenkins-instance-profile"
  role = data.aws_iam_role.jenkins_role.name
}

# Attach policies to the EKS worker node role
resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = data.aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = data.aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = data.aws_iam_role.eks_worker_node_role.name
}

# Attach the policy to the control plane role
resource "aws_iam_role_policy_attachment" "eks_control_plane_policy" {
  role       = data.aws_iam_role.eks_control_plane_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
