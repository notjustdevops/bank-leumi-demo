# Create IAM role for Jenkins to interact with other AWS services
resource "aws_iam_role" "jenkins_role" {
  name = "${var.resource_name_prefix}-jenkins-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-jenkins-role" })
}

# Attach an inline policy to allow Jenkins to access S3, ECR, EC2, and Secrets Manager
resource "aws_iam_role_policy" "jenkins_policy" {
  role = aws_iam_role.jenkins_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "${var.s3_backup_arn}",
          "${var.s3_backup_arn}/*"
        ]
      },
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:PutSecretValue"
        ],
        Effect   = "Allow",
        Resource = aws_secretsmanager_secret.jenkins_admin_password.arn  # Restrict to the specific secret
      }
    ]
  })
}

# Store Jenkins admin password in Secrets Manager
resource "aws_secretsmanager_secret" "jenkins_admin_password" {
  name        = "${var.resource_name_prefix}-jenkins-admin-password"
  description = "Jenkins admin password"

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-jenkins-admin-password" })
}

resource "aws_secretsmanager_secret_version" "jenkins_admin_password_value" {
  secret_id     = aws_secretsmanager_secret.jenkins_admin_password.id
  secret_string = var.jenkins_admin_password   # Pass your secret securely

  lifecycle {
    prevent_destroy = true
  }
}

# Retrieve Jenkins admin password from Secrets Manager
data "aws_secretsmanager_secret_version" "jenkins_admin_password" {
  secret_id = aws_secretsmanager_secret.jenkins_admin_password.arn
}

# Use the Jenkins admin password in Helm release
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  set {
    name  = "controller.adminPassword"
    value = data.aws_secretsmanager_secret_version.jenkins_admin_password.secret_string
  }
}
