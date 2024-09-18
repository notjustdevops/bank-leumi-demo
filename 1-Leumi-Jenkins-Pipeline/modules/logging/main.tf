# path: Leumi-Jenkins-Pipeline/modules/logging/main.tf

resource "aws_cloudwatch_log_group" "jenkins_log_group" {
  name              = "/jenkins/logs"
  retention_in_days = 30

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-jenkins-logs" })
}

resource "aws_iam_role_policy" "jenkins_logging_policy" {
  role = var.jenkins_iam_role_arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "${aws_cloudwatch_log_group.jenkins_log_group.arn}:*"
      }
    ]
  })
}
