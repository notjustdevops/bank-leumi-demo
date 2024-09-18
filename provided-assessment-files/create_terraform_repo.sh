#!/bin/bash

# Set the repo name
REPO_NAME="5-Terraform-Task"

# Create the root repo folder
mkdir -p "$REPO_NAME"

# Navigate to the repo
cd "$REPO_NAME" || exit

# Create the main directories for modules and environments
mkdir -p modules/ec2 modules/nlb modules/iam modules/vpc modules/common env/dev env/prod .github/workflows scripts

# Create centralized variables for tags and resource names in a common directory
cat <<EOL > modules/common/variables.tf
# Define tags and resource names centrally

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {
    Name      = "Bank-Leumi-Demo"
    Owner     = "Dvorkin Guy"
    Terraform = "True"
  }
}

variable "resource_name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "dvorkinguy-leumi-demo"
}

variable "env_tag" {
  description = "Environment-specific tag"
  type        = string
}
EOL

# Create Terragrunt files for dev and prod environments
cat <<EOL > env/dev/terragrunt.hcl
# terragrunt.hcl (dev environment)

dependency "vpc" {
  config_path = "../vpc"
}

dependency "latest_ami" {
  config_path = "../ec2"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  subnet_id             = dependency.vpc.outputs.subnet_id
  ami                   = dependency.latest_ami.outputs.ami_id
  common_tags           = merge(dependency.common.outputs.common_tags, { Env = "Dev" })
  resource_name_prefix  = "dvorkinguy-leumi-demo"
}
EOL

cat <<EOL > env/prod/terragrunt.hcl
# terragrunt.hcl (prod environment)

dependency "vpc" {
  config_path = "../vpc"
}

dependency "latest_ami" {
  config_path = "../ec2"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  subnet_id             = dependency.vpc.outputs.subnet_id
  ami                   = dependency.latest_ami.outputs.ami_id
  common_tags           = merge(dependency.common.outputs.common_tags, { Env = "Prod" })
  resource_name_prefix  = "dvorkinguy-leumi-demo"
}
EOL

# Create Terraform variables files for environments
cat <<EOL > env/dev/terraform.tfvars
# terraform.tfvars (dev environment)

instance_type = "t2.micro"
key_name      = "dvorkinguy-leumi-demo-dev-key"
EOL

cat <<EOL > env/prod/terraform.tfvars
# terraform.tfvars (prod environment)

instance_type = "t2.medium"
key_name      = "dvorkinguy-leumi-demo-prod-key"
EOL

# Create backend config files for secure remote state storage
cat <<EOL > env/dev/backend.hcl
# backend.hcl (dev environment)

remote_state {
  backend = "s3"

  config = {
    bucket         = "dvorkinguy-leumi-demo-dev-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = dependency.vpc.outputs.dynamodb_table_name  # Use from dependency
  }
}
EOL

cat <<EOL > env/prod/backend.hcl
# backend.hcl (prod environment)

remote_state {
  backend = "s3"

  config = {
    bucket         = "dvorkinguy-leumi-demo-prod-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = dependency.vpc.outputs.dynamodb_table_name
  }
}
EOL

# Create the EC2 module files with centralized tags and names
cat <<EOL > modules/ec2/main.tf
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
EOL

# EC2 Variables
cat <<EOL > modules/ec2/variables.tf
# EC2 Module Variables

variable "ami" {
  description = "The AMI ID to use"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to place the EC2 instance"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "env_tag" {
  description = "Environment tag"
  type        = string
}
EOL

# EC2 Outputs
cat <<EOL > modules/ec2/outputs.tf
# EC2 Outputs

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.test_ec2.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.test_ec2.id
}

# Output for latest AMI
output "ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}
EOL

# Create the IAM module files with centralized tags and names
cat <<EOL > modules/iam/main.tf
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
EOL

# IAM Variables and Outputs
cat <<EOL > modules/iam/variables.tf
# IAM Module Variables

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "env_tag" {
  description = "Environment tag"
  type        = string
}
EOL

cat <<EOL > modules/iam/outputs.tf
# IAM Module Outputs
EOL

# Create the NLB module files with centralized tags and names
cat <<EOL > modules/nlb/main.tf
# NLB Setup

resource "aws_lb" "test_nlb" {
  name               = "${var.resource_name_prefix}-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = var.subnet_id
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}
EOL

# NLB Variables and Outputs
cat <<EOL > modules/nlb/variables.tf
# NLB Module Variables

variable "subnet_id" {
  description = "The subnet ID for the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "env_tag" {
  description = "Environment tag"
  type        = string
}
EOL

cat <<EOL > modules/nlb/outputs.tf
# NLB Outputs

output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.test_nlb.dns_name
}
EOL

# Create the VPC module files with centralized tags and names
cat <<EOL > modules/vpc/main.tf
# VPC Setup

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, { Env = var.env_tag })
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = merge(var.common_tags, { Env = var.env_tag })
}

# DynamoDB Table for Terraform state locking
resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "${var.resource_name_prefix}-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}
EOL

# VPC Variables
cat <<EOL > modules/vpc/variables.tf
# VPC Module Variables

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "env_tag" {
  description = "Environment tag"
  type        = string
}
EOL

# VPC Outputs
cat <<EOL > modules/vpc/outputs.tf
# VPC Outputs

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
}
EOL

# Create a GitHub Actions workflow for CI/CD with debugging stages and DockerHub secrets
cat <<EOL > .github/workflows/terraform.yml
name: Deploy Infrastructure

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1

      - name: Install dependencies
        run: sudo apt-get install -y terragrunt

      - name: Debug Environment Variables
        run: env | sort

      - name: Initialize Terragrunt
        run: terragrunt init
        
      - name: Plan Infrastructure
        run: terragrunt plan

      - name: Apply Infrastructure
        run: terragrunt apply -auto-approve

      - name: DockerHub Login
        run: echo \${{ secrets.DOCKERHUB_PASSWORD }} | docker login -u \${{ secrets.DOCKERHUB_USERNAME }} --password-stdin

      - name: Build and Push Docker Image
        run: docker build -t \${{ secrets.DOCKERHUB_USERNAME }}/demo-app .
        run: docker push \${{ secrets.DOCKERHUB_USERNAME }}/demo-app

      env:
        AWS_ACCESS_KEY_ID: \${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: \${{ secrets.AWS_SECRET_ACCESS_KEY }}
EOL

# Make the script executable
chmod +x scripts/setup.sh

# Create .gitignore
cat <<EOL > .gitignore
# Ignore Terraform and Terragrunt files
*.tfstate
*.tfstate.*
.terraform/
.terragrunt-cache/
EOL

# Create a README.md
cat <<EOL > README.md
# 5-Terraform-Task

This repository contains a Terraform project deployed with Terragrunt. It sets up an EC2 instance running Apache, assigns a fixed Elastic IP (VIP), and configures a Network Load Balancer (NLB) following security best practices for the banking industry.

## Security Best Practices:
- All S3 buckets for Terraform state are encrypted at rest.
- IAM policies follow the principle of least privilege.
- Security Groups restrict inbound access to the Leumi proxy IP address (91.231.246.50).
- Detailed monitoring enabled on EC2 instances for auditing purposes.

## Instructions:
1. Install Terraform and Terragrunt.
2. Clone this repository.
3. Navigate to the \`env/dev\` directory and run the following commands:
   \`\`\`
   terragrunt init
   terragrunt apply -auto-approve
   \`\`\`

## Structure:
- \`modules/\`: Contains reusable Terraform modules for EC2, NLB, VPC, IAM.
- \`env/\`: Environment-specific configuration files for Terragrunt.
- \`scripts/\`: Helper scripts for running Terraform commands.
- \`.github/\`: GitHub Actions workflows for CI/CD automation with DockerHub integration.
EOL

echo "Repository structure created successfully."

