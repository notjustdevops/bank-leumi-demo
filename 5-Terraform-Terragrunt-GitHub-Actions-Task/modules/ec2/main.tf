# EC2 Instance Setup

resource "aws_instance" "test_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = merge(var.common_tags, { Env = var.env_tag })

  monitoring = true  # Enable CloudWatch detailed monitoring for banking compliance
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.resource_name_prefix}-ec2-sg"
  description = "Allow HTTP from Leumi proxy only"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["91.231.246.50/32"]  # Restrict access to Leumi proxy
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}
