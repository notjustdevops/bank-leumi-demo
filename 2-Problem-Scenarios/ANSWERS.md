# Question #2.a: DNS Resolution Failure:
- The TEST EC2 instance is unable to resolve DNS for external internet addresses. What are the potential failure points that you would investigate?

---

# Answer #2.a: DNS Resolution Failure:

### **Investigation Steps:**

1. **Check DNS Configuration on EC2**:
   - Ensure that the `/etc/resolv.conf` file on the TEST EC2 instance (10.181.242.10) in the TEST Spoke VPC (10.181.242.0/24) is pointing to the correct DNS server, such as `169.254.169.253` (AWS DNS server).

2. **Check Security Group Rules**:
   - Ensure that the security group associated with the TEST EC2 instance (10.181.242.10) in the TEST Spoke VPC (10.181.242.0/24) allows outbound traffic on port 53 for DNS queries (both TCP and UDP).

3. **Verify Route Table**:
   - Verify that the route table associated with the TEST EC2 instance in the TEST Spoke VPC (10.181.242.0/24) has a route for external traffic (0.0.0.0/0) pointing to the NAT Gateway in the Egress VPC (10.181.241.0/24).

4. **Check NAT Gateway in the Egress VPC**:
   - Ensure that the NAT Gateway in the Egress VPC (10.181.241.0/24) is operational and properly configured to provide internet access to the TEST EC2 instance (10.181.242.10) in the TEST Spoke VPC.

5. **Inspect Firewall (NFW) Rules**:
   - Inspect the Network Firewall (NFW) between the NAT Gateway in the Egress VPC (10.181.241.0/24) and the external internet to ensure that outbound DNS traffic (port 53) and general internet traffic are not blocked by the firewall.

6. **Verify DNS Resolver in Inspection VPC (Checkpoint)**:
   - If a custom DNS resolver is used, such as Route 53 or the Checkpoint Firewall in the Inspection VPC (10.181.2.0/24), ensure that the TEST EC2 instance (10.181.242.10) can communicate with this DNS resolver.

7. **Check Transit Gateway (DEV TGW)**:
   - Ensure that the DEV Transit Gateway (TGW) properly routes traffic between the TEST Spoke VPC (10.181.242.0/24) and the Egress VPC (10.181.241.0/24), allowing the TEST EC2 instance to reach the NAT Gateway for internet access.

---

# Question #2.b: DNS Resolving but No Internet Communication
- The TEST EC2 instance successfully resolves DNS but cannot communicate with the internet. What could be the possible cause of the issue?

---

# Answer #2.b:

### **Things to Check:**

1. **Route Table Checks**:
   - The TEST EC2 instance in **TEST Spoke VPC (10.181.242.0/24)** needs a route to the internet. Check if the route table in the TEST Spoke VPC has a route for all traffic (0.0.0.0/0) pointing to the NAT Gateway in the **Egress VPC (10.181.241.0/24)**.

2. **NAT Gateway Health**:
   - The NAT Gateway in the **Egress VPC (10.181.241.0/24)** is responsible for allowing private instances like TEST EC2 to access the internet. Make sure the NAT Gateway is functional and linked to the correct route.

3. **Firewall Rules**:
   - Check the NFW (Network Firewall) between the NAT Gateway and the internet in the Egress VPC. It should allow outbound HTTP and HTTPS traffic on ports 80 and 443. Sometimes DNS works, but the firewall might block other internet traffic.

4. **Security Group Settings**:
   - The security group assigned to the TEST EC2 instance (10.181.242.10) should allow outbound HTTP (port 80) and HTTPS (port 443) traffic. Check that outbound rules aren't too restrictive and block internet communication.

5. **Network ACL Check**:
   - Make sure that the Network ACLs (NACLs) in the TEST Spoke VPC (10.181.242.0/24) allow outbound traffic for HTTP (port 80) and HTTPS (port 443). ACLs can sometimes allow DNS (port 53) but block other traffic if misconfigured.

6. **Transit Gateway Routes**:
   - Check if the DEV Transit Gateway (TGW), which connects the TEST Spoke VPC and Egress VPC, is routing traffic correctly. The TEST EC2 instance (10.181.242.10) needs a proper route through the DEV TGW to the NAT Gateway in the Egress VPC for internet access.

---

# Question #2.c: Docker Issues on TEST EC2:
- On the TEST EC2 instance, Docker is installed, and the repository is hosted in a VPC alm on the Nexus repo machine. Investigate the following errors:
  - Error 1: `pull access denied`
  - Error 2: `container pull timeout`
  - Error 3: `docker daemon is not running`

---

# Answer #2.c: Docker Issues on TEST EC2:

### Things to Check:

1. **Error 1: `pull access denied`**:
   - This usually happens when Docker doesn’t have the right permissions to pull the image from the Nexus repository.
   - Things to look at:
     - **Authentication**: Check if Docker is logged in to the Nexus repo with the right credentials. Try running `docker login` again and make sure you’re using the correct username and password.
     - **Repository Permissions**: Make sure the user has permission to access the repo in the VPC alm. You’ll need to verify the access settings on the Nexus machine.
     - **Image Name**: Double-check that the image name and tag you’re pulling are correct—typos or wrong tags could be the issue.

2. **Error 2: `container pull timeout`**:
   - This error usually means Docker can’t reach the Nexus repository, so it’s likely a networking issue.

   - What to check:
     - **Network Connectivity**: Make sure the TEST EC2 instance (10.181.242.10) in the TEST Spoke VPC (10.181.242.0/24) can actually reach the Nexus EC2 instance (10.181.8.10) in the ALM Spoke VPC (10.181.8.0/24). 
     
     You can use `ping` or `telnet` to see if the machines can communicate over the right port (check the Nexus repo port, like 8081 for HTTP).
   
     - **Firewall and Security Group Rules**: Make sure both the TEST EC2 and Nexus EC2 have security group rules allowing traffic on the necessary ports. Also, make sure no Network ACLs (NACLs) are blocking traffic between the VPCs.
   
     - **Route Table Configuration**: Check the route tables to ensure there’s a valid path between the TEST Spoke VPC and the ALM Spoke VPC, possibly through the DEV TGW.

3. **Error 3: `docker daemon is not running`**:
   - This is pretty clear—the Docker service isn’t running.

   - Steps to take:
     - **Check Docker Service Status**: Use `systemctl status docker` to check if the service is running. If it’s stopped, try restarting it with `sudo systemctl start docker`.

     - **Docker Installation**: Confirm that Docker is installed properly on the TEST EC2 instance. Run `docker --version` to check that Docker is available.

     - **Check Logs for Errors**: If Docker won’t start, look at the logs with `journalctl -u docker` to see if there are any errors that explain what’s going on.

     - **Reboot**: Sometimes just rebooting the instance can fix Docker issues. Try `sudo reboot`.