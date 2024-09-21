## Task Instructions:

### 1. Jenkins Pipeline:

- You are required to create a Jenkins process based on a Jenkins Declarative Pipeline. 
- The pipeline will build an application, based on Python, on one server, wrap it with Docker, and run it after the build process on another server in a POD (Kubernetes) configuration.
- This application should be exposed externally on port 443.

#### Requirements:
- Upload the complete solution to a GitHub repository.
- The solution must run properly without errors.

---

### **Stack List**

#### **1. Infrastructure Management**
- **AWS Cloud**:
  - **Amazon VPC**: Isolated network for secure communication.
  - **Amazon EKS**: Kubernetes cluster for running the application in PODs.
  - **Amazon EC2**: To host Jenkins and auxiliary services.
  - **Amazon S3**: To store Terraform state files.
  - **Amazon DynamoDB**: To lock the Terraform state.
  - **Amazon Route 53**: DNS management for leumi.notjustdevops.com.
  - **Amazon Certificate Manager (ACM)**: Manage SSL/TLS certificates for secure connections (port 443).
  - **Amazon EFS**: Persistent storage for Jenkins and Kubernetes.

- **Terraform**: Used to define and provision AWS infrastructure.
- **Terragrunt**: To manage Terraform configurations across environments (DEV, STAGING, PROD).

#### **2. Continuous Integration/Continuous Deployment (CI/CD)**
- **Jenkins**:
  - Declarative Pipeline for automating build, test, and deployment processes.
  - DockerHub for storing containerized Python app images.
  - Helm for managing Kubernetes deployments (EKS).
  - Blue/Green deployment with automated rollback using Kubernetes and Helm.

#### **3. Containerization & Orchestration**
- **Docker**: To containerize the Python application.
- **Kubernetes (EKS)**: To manage the application lifecycle, scaling, and load balancing.
  - **Helm**: For Kubernetes application packaging and Blue/Green releases.
  - **Ingress (NGINX or AWS ALB)**: To manage traffic routing and expose the app externally on port 443.

#### **4. Monitoring & Alerts**
- **Prometheus**: To monitor Kubernetes and application metrics.
- **Grafana**: To visualize performance and logs.
- **AWS CloudWatch**: To collect and monitor logs for Jenkins and Kubernetes.
- **Slack Alerts**: Integrated for real-time failure notifications.

#### **5. Security & Storage**
- **IAM Roles & Policies**: Manage permissions for AWS resources.
- **AWS Secrets Manager**: Securely store sensitive data (e.g., DockerHub, Jenkins credentials).
- **TLS/SSL Certificates**: Managed via ACM for HTTPS access on port 443.

#### **6. Backup & Disaster Recovery**
- **Amazon EFS**: For persistent storage of Jenkins and Kubernetes configuration.
- **Automated Backups**: For Jenkins configurations and Kubernetes data, stored in S3 for disaster recovery.


---

### **Phase 1: Infrastructure Setup**

1. **Step 1: Setup Version Control and Project Structure**
   - **Create a GitHub repository** for the project.
   - Push the initial project structure (including directories like `ci_cd`, `environments`, `modules`, `helm`, `src`, etc.).
   - **Confirm:** Ensure your project tree is correct by checking in the repository.

2. **Step 2: AWS VPC, Subnets, and Security Groups**
   - **Create the VPC** with public and private subnets using Terraform modules in the `modules/vpc` directory.
   - Define security groups to allow necessary traffic (e.g., HTTP/HTTPS, Jenkins access, EKS).
   - **Confirm:** After applying Terraform, check in the AWS Console to ensure the VPC, subnets, and security groups are properly created.

3. **Step 3: S3 Bucket and DynamoDB Table for Terraform State**
   - Create an S3 bucket with versioning enabled for Terraform state and a DynamoDB table for state locking (manually or through Terraform).
   - **Confirm:** Ensure the S3 bucket and DynamoDB table are created and working by running basic `terraform init` and `terraform apply` in your `dev` environment.


4. **Step 4: Create EC2 and Amazon EKS Cluster**
   - Use the Terraform module in the `modules/eks` directory to create the EKS cluster.
   - Configure the worker nodes, autoscaling, and IAM roles.
   - **Confirm:** After applying Terraform, validate the EKS cluster by checking the AWS Console or using the `kubectl` command to interact with the cluster (e.g., `kubectl get nodes`).


### **Phase 2: Jenkins Setup**

5. **Step 5: Jenkins on EC2 with EFS for Storage**
   - Provision an EC2 instance using the `modules/ec2` Terraform module.
   - Attach EFS for persistent storage of Jenkins configuration and jobs.
   - Install Jenkins on the EC2 instance.

   - **Confirm:** Access **Jenkins** via its public IP or DNS, and ensure the persistent storage is working by restarting Jenkins and checking if the configurations persist.

6. **Step 6: Route 53 DNS and SSL/TLS with ACM**
   - Set up Route 53 DNS for your domain (`leumi.notjustdevops.com`) using AWS CLI or Terraform.
   - Request SSL/TLS certificates through ACM and attach them to the Load Balancer.
   - **Confirm:** Ensure the domain is pointing correctly and SSL is working by visiting `https://<your-domain>` and verifying the certificate.

### **Phase 3: CI/CD Pipeline and Application Deployment**

7. **Step 7: Build Jenkins Pipeline (Initial Build Only)**
   - Define the Jenkins pipeline in the `Jenkinsfile` that performs the following:
     - Checkout code from GitHub.
     - Build the Docker image for the Python app.
     - Push the Docker image to DockerHub.
   - **Confirm:** Run the pipeline and ensure the Docker image is pushed successfully to DockerHub.

8. **Step 8: Create Kubernetes Helm Deployment (Basic Deployment)**
   - Define Helm charts (`helm/charts/my-app`) for deploying the Python app to EKS.
   - Ingress should expose the application on port 443 using the SSL certificate from ACM.
   - **Confirm:** Run Helm deployment (`helm install`) and check that the app is accessible via `https://<your-domain>`.

9. **Step 9: Automate Blue/Green Deployment**
   - Create a Blue/Green deployment strategy using Helm charts.
   - Modify the Jenkins pipeline to deploy the new version as part of the blue/green switch.
   - **Confirm:** Test the Blue/Green deployment by updating the application and confirming the switch between the old and new versions via Helm.

### **Phase 4: Monitoring, Alerts, and Logging**

10. **Step 10: Setup Prometheus and Grafana**
    - Deploy Prometheus and Grafana in the EKS cluster using Helm.
    - Add monitoring for Jenkins, EKS, and the Python application.
    - **Confirm:** Access Grafana via the exposed URL and check if metrics are being collected from Prometheus.

11. **Step 11: Integrate CloudWatch Logging and Slack Alerts**
    - Set up CloudWatch for Jenkins logs and Kubernetes logs (using Fluentd or similar).
    - Configure CloudWatch alarms to trigger Slack alerts on failures or errors.
    - **Confirm:** Test the alarms by triggering a build failure or app failure and check if the alerts are sent to Slack.

### **Phase 5: Backup and Disaster Recovery**

12. **Step 12: Automate Backups for Jenkins and Kubernetes**
    - Set up a backup mechanism for Jenkins and Kubernetes data using Amazon EFS and S3.
    - **Confirm:** Run a backup and ensure data is saved to S3 correctly, and test restoration procedures.

### **Phase 6: Final Testing and Deployment**

13. **Step 13: Final Testing of Full Pipeline**
    - Run a full Jenkins pipeline build and deploy the application to EKS using the complete setup.
    - Ensure Blue/Green deployment, HTTPS access, and monitoring are all functioning correctly.
    - **Confirm:** Validate everything end-to-end, including pipeline success, Blue/Green deployment, and application availability.

14. **Step 14: Move to Production**
    - Repeat the process in the `prod` environment using the `environments/prod` Terragrunt configurations.
    - **Confirm:** Ensure everything is working in the production environment with all configurations.

---

### **Priority Actions**:
1. **Networking (VPC, Subnets, Security Groups)**: Build the foundation for secure and isolated networking.
2. **State Management (S3, DynamoDB)**: Set up state management to ensure safe infrastructure provisioning.
3. **EKS Cluster and EC2 Setup**: Provision compute resources to run Kubernetes and Jenkins.
4. **SSL/TLS and DNS Setup**: Secure application access via Route 53 and ACM.
5. **CI/CD Pipeline**: Automate the build and deployment of your application with Jenkins and Helm.
6. **Monitoring and Alerts**: Implement real-time monitoring and alerting with Prometheus, Grafana, and CloudWatch.
7. **Backup and Recovery**: Ensure Jenkins and application data are backed up and can be recovered from failures.


