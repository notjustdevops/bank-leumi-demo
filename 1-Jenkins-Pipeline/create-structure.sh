#!/bin/bash

# Define base directory
BASE_DIR="/home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline"

# Create the main directory structure
mkdir -p ${BASE_DIR}/{environments/{dev/{vpc,eks,jenkins,monitoring,ingress,s3,dynamodb},staging,prod},modules/{vpc,eks,jenkins,monitoring,ingress,s3,dynamodb,acm,efs,iam,secrets_manager},ci_cd/scripts,helm/charts/my-app/templates,src/app,monitoring/grafana/dashboards}

# Create root-level terragrunt.hcl for the dev environment
cat <<EOF > ${BASE_DIR}/environments/dev/terragrunt.hcl
terraform {
  source = "path_to_your_root_module"
}

inputs = {
  resource_name_prefix = "dvorkinguy-leumi-jenkins"
  aws_region           = "us-west-2"
  common_tags = {
    Name        = "Leumi-Jenkins"
    Owner       = "Dvorkin Guy"
    Environment = "Dev"
    Version     = "0.0.2"
  }
}
EOF

# Create environment-specific tfvars for dev
cat <<EOF > ${BASE_DIR}/environments/dev/terraform.tfvars
vpc_cidr = "10.0.0.0/16"
eks_instance_type = "t3.medium"
number_of_nodes = 3
EOF

# Create placeholder files in environments/dev/ for module-specific terragrunt.hcl files
for module in vpc eks jenkins monitoring ingress s3 dynamodb acm efs iam secrets_manager; do
    mkdir -p ${BASE_DIR}/environments/dev/${module}
    cat <<EOF > ${BASE_DIR}/environments/dev/${module}/terragrunt.hcl
terraform {
  source = "../../../modules//${module}"
}

include {
  path = find_in_parent_folders()
}
EOF
done

# Create placeholder files in environments/staging/ and environments/prod/ (same structure as dev)
for env in staging prod; do
    mkdir -p ${BASE_DIR}/environments/${env}/{vpc,eks,jenkins,monitoring,ingress,s3,dynamodb,acm,efs,iam,secrets_manager}
    for module in vpc eks jenkins monitoring ingress s3 dynamodb acm efs iam secrets_manager; do
        cat <<EOF > ${BASE_DIR}/environments/${env}/${module}/terragrunt.hcl
terraform {
  source = "../../../modules//${module}"
}

include {
  path = find_in_parent_folders()
}
EOF
    done
done

# Create placeholder files for Terraform modules
for module in vpc eks jenkins monitoring ingress s3 dynamodb acm efs iam secrets_manager; do
    mkdir -p ${BASE_DIR}/modules/${module}
    touch ${BASE_DIR}/modules/${module}/{main.tf,outputs.tf,variables.tf}
done

# CI/CD scripts and Jenkinsfile
touch ${BASE_DIR}/ci_cd/Jenkinsfile
touch ${BASE_DIR}/ci_cd/scripts/{docker_build.sh,helm_deploy.sh,blue_green_switch.sh}

# Helm chart files
touch ${BASE_DIR}/helm/charts/my-app/{Chart.yaml,values.yaml}
touch ${BASE_DIR}/helm/charts/my-app/templates/{deployment.yaml,service.yaml,ingress.yaml}

# Source code files
touch ${BASE_DIR}/src/app/{main.py,requirements.txt,Dockerfile}

# Monitoring files
touch ${BASE_DIR}/monitoring/prometheus.yaml
touch ${BASE_DIR}/monitoring/grafana/{grafana-values.yaml,dashboards/my-dashboard.json}

# README and terraform state
touch ${BASE_DIR}/{README.md,terraform.tfstate}

echo "Project structure and terragrunt files created successfully at ${BASE_DIR}"
