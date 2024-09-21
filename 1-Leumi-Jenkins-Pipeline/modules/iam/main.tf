# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/modules/iam/main.tf

terraform {
  backend "s3" {}
}

# IAM role for Jenkins to interact with AWS services
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

# IAM policy for Jenkins to access S3, ECR, EC2, and Secrets Manager
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
          "secretsmanager:DescribeSecret"
        ],
        Effect   = "Allow",
        Resource = "${data.aws_secretsmanager_secret.jenkins_admin_password.arn}"  # Correct reference to the secret ARN
      }
    ]
  })
}

# Retrieve Jenkins admin password from AWS Secrets Manager
data "aws_secretsmanager_secret" "jenkins_admin_password" {
  name = "dvorkinguy-leumi-jenkins-admin-password"
}
