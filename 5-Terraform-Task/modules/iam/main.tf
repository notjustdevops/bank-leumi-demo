# IAM role and instance profile for EC2

resource "aws_iam_role" "ec2_role" {
  name = "${var.resource_name_prefix}-ec2-role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = merge(var.common_tags, { Env = var.env_tag })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.resource_name_prefix}-ec2-policy"
  description = "Policy for EC2 access to S3 and CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.resource_name_prefix}-*"
    },
    {
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.resource_name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(var.common_tags, { Env = var.env_tag })
}
