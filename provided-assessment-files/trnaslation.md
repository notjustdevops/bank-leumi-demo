# Cloud Infrastructure Team Exam - Leumi Bank

## Task Instructions:

### 1. Jenkins Pipeline:


- You are required to create a Jenkins process based on a Jenkins Declarative Pipeline. 
- The pipeline will build an application, based on Python, on one server, wrap it with Docker, and run it after the build process on another server in a POD (Kubernetes) configuration.
- This application should be exposed externally on port 443.

#### Requirements:
- Upload the complete solution to a GitHub repository.
- The solution must run properly without errors.

### 2. Problem Scenarios:

#### a. DNS Resolution Failure:
- The TEST EC2 instance is unable to resolve DNS for external internet addresses. What are the potential failure points that you would investigate?

#### b. DNS Resolving but No Internet Communication:
- The TEST EC2 instance successfully resolves DNS but cannot communicate with the internet. What could be the possible cause of the issue?

#### c. Docker Issues on TEST EC2:
- On the TEST EC2 instance, Docker is installed, and the repository is hosted in a VPC alm on the Nexus repo machine. Investigate the following errors:
  - Error 1: `pull access denied`
  - Error 2: `container pull timeout`
  - Error 3: `docker daemon is not running`



### 3. HTTPS Service Exposure:

- A service needs to be exposed to the internet using a DNS record, referencing the TEST EC2 machine.
- When accessing the service externally, the public IP address of the TEST EC2 instance is received, but you are unable to access the service via HTTPS. What steps would you check in the flow to troubleshoot?




### 4. Telnet Installation Issue:

- While attempting to run `telnet` on the TEST EC2 instance, you receive an error indicating the software is missing.
- How would you install `telnet` on an Amazon Linux 2 instance? What might cause the installation failure, and how would you solve it using the appropriate repository and command?

---

### 5. Terraform Task:

#### a. EC2 Instance Setup:

- Write a Terraform file (`.tf`) that will create an EC2 instance similar to the TEST EC2 instance, based on Linux.
- The machine must:
  - Run Apache on port 80 (HTTP protocol).
  - Have a fixed public IP address (VIP).
  - Be configured with a Security Group (SG) that only allows access from the Leumi proxy IP address: `91.231.246.50`.

#### b. Access via NLB:

- Make the machine from Task 1 accessible via a Network Load Balancer (NLB).
