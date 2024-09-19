#!/bin/bash

# Define the base path for your dev environment
BASE_PATH="/home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Leumi-Jenkins-Pipeline/environments/dev"

# Create the subfolders for each module
mkdir -p $BASE_PATH/vpc
mkdir -p $BASE_PATH/ec2
mkdir -p $BASE_PATH/eks
mkdir -p $BASE_PATH/jenkins
mkdir -p $BASE_PATH/ecr
mkdir -p $BASE_PATH/helm-k8s
mkdir -p $BASE_PATH/security
mkdir -p $BASE_PATH/monitoring
mkdir -p $BASE_PATH/dynamodb
mkdir -p $BASE_PATH/s3
mkdir -p $BASE_PATH/logging
mkdir -p $BASE_PATH/backup-recovery
mkdir -p $BASE_PATH/iam

# Create an empty terragrunt.hcl file in each folder
touch $BASE_PATH/vpc/terragrunt.hcl
touch $BASE_PATH/ec2/terragrunt.hcl
touch $BASE_PATH/eks/terragrunt.hcl
touch $BASE_PATH/jenkins/terragrunt.hcl
touch $BASE_PATH/ecr/terragrunt.hcl
touch $BASE_PATH/helm-k8s/terragrunt.hcl
touch $BASE_PATH/security/terragrunt.hcl
touch $BASE_PATH/monitoring/terragrunt.hcl
touch $BASE_PATH/dynamodb/terragrunt.hcl
touch $BASE_PATH/s3/terragrunt.hcl
touch $BASE_PATH/logging/terragrunt.hcl
touch $BASE_PATH/backup-recovery/terragrunt.hcl
touch $BASE_PATH/iam/terragrunt.hcl

# Create the root terragrunt.hcl and backend.hcl files in the dev folder
touch $BASE_PATH/terragrunt.hcl
touch $BASE_PATH/backend.hcl

echo "Folder structure and files created successfully!"
