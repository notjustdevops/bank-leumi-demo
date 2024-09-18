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
3. Navigate to the `env/dev` directory and run the following commands:
   ```
   terragrunt init
   terragrunt apply -auto-approve
   ```

## Structure:
- `modules/`: Contains reusable Terraform modules for EC2, NLB, VPC, IAM.
- `env/`: Environment-specific configuration files for Terragrunt.
- `scripts/`: Helper scripts for running Terraform commands.
- `.github/`: GitHub Actions workflows for CI/CD automation with DockerHub integration.
