#!/bin/bash

# Set repository name
REPO_NAME="Leumi-Jenkins-Pipeline"

# Create base directory for the repository
mkdir -p $REPO_NAME

# Function to create directories
create_directories() {
  mkdir -p $REPO_NAME/{app,environments/dev,modules/{helm-k8s/charts/python-app/templates,ecr,eks,ec2,vpc,iam,security,backup-recovery,s3,dynamodb,jenkins,monitoring,logging}}
}

# Function to create files
create_files() {
  # Create README.md in the root directory
  touch $REPO_NAME/README.md

  # Create terraform.tfvars in the root directory for centralized Terraform variables
  touch $REPO_NAME/terraform.tfvars

  # Create Jenkinsfile in the root directory for the Jenkins pipeline
  touch $REPO_NAME/Jenkinsfile

  # Create Dockerfile in the root directory for Docker image creation
  touch $REPO_NAME/Dockerfile

  # Create centralized Helm values file in the root directory
  touch $REPO_NAME/helm-values.yaml

  # Create app files (main.py and requirements.txt) in the app directory
  touch $REPO_NAME/app/main.py
  touch $REPO_NAME/app/requirements.txt

  # Create the Terragrunt configuration file for dev environment
  touch $REPO_NAME/environments/dev/terragrunt.hcl

  # Create backend.hcl for dev environment for remote state configuration
  touch $REPO_NAME/environments/dev/backend.hcl

  # Create VPC module files
  touch $REPO_NAME/modules/vpc/{main.tf,variables.tf,outputs.tf}

  # Create EC2 AMI lookup and instance files
  touch $REPO_NAME/modules/ec2/{ami.tf,instance.tf,outputs.tf,variables.tf}

  # Create ECR module files
  touch $REPO_NAME/modules/ecr/{main.tf,variables.tf,outputs.tf}

  # Create EKS module files
  touch $REPO_NAME/modules/eks/{main.tf,variables.tf,outputs.tf}

  # Create IAM module files
  touch $REPO_NAME/modules/iam/{main.tf,variables.tf,outputs.tf}

  # Create Security module files
  touch $REPO_NAME/modules/security/{main.tf,variables.tf,outputs.tf}

  # Create Backup and Recovery module files
  touch $REPO_NAME/modules/backup-recovery/{main.tf,variables.tf,outputs.tf}

  # Create S3 module files
  touch $REPO_NAME/modules/s3/{main.tf,variables.tf,outputs.tf}

  # Create DynamoDB module files
  touch $REPO_NAME/modules/dynamodb/{main.tf,variables.tf,outputs.tf}

  # Create Jenkins module files
  touch $REPO_NAME/modules/jenkins/{main.tf,variables.tf,outputs.tf}

  # Create Helm module files (helm-k8s)
  touch $REPO_NAME/modules/helm-k8s/main.tf
  touch $REPO_NAME/modules/helm-k8s/charts/python-app/Chart.yaml
  touch $REPO_NAME/modules/helm-k8s/charts/python-app/values.yaml

  # Create Helm chart templates (deployment, service, ingress)
  touch $REPO_NAME/modules/helm-k8s/charts/python-app/templates/{deployment.yaml,service.yaml,ingress.yaml}

  # Create Monitoring module files (for Prometheus and Grafana)
  touch $REPO_NAME/modules/monitoring/{main.tf,variables.tf,outputs.tf}

  # Create Logging module files (for CloudWatch)
  touch $REPO_NAME/modules/logging/{main.tf,variables.tf,outputs.tf}
}

# Run the functions to create the directories and files
create_directories
create_files

echo "Project structure and empty files for '$REPO_NAME' created successfully."
