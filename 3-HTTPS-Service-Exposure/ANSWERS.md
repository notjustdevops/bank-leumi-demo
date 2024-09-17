
# Question #3: HTTPS Service Exposure:

- A service needs to be exposed to the internet using a DNS record, referencing the TEST EC2 machine.
- When accessing the service externally, the public IP address of the TEST EC2 instance is received, but you are unable to access the service via HTTPS. What steps would you check in the flow to troubleshoot?


# Answer #3: Troubleshooting Steps for HTTPS Service Exposure

## 1. Check Solution Architecture
- First, I would check if the provided architecture diagram is correct. I'll make sure that all components are placed properly, such as VPC, TGW, and other services like the firewall and DNS. 
- Next, I will ensure that all services are deployed as per the diagram and confirm they are up and running.

## 2. Check Security Groups
- **Action**: Ensure the security group linked to the TEST EC2 instance allows inbound HTTPS traffic on port 443.
- **Verification**: Confirm that it's open to either all (`0.0.0.0/0`) or specific IP addresses.
- **Importance**: Security groups often block connections if not properly configured.

## 3. Verify Network ACLs
- **Action**: Check if the Network ACLs for the VPC allow both inbound and outbound traffic on port 443.
- **Verification**: Ensure both directions are open as NACLs are stateless.
- **Importance**: Incorrect NACLs can block traffic even when security groups are correct.

## 4. Inspect VPC and Subnet Configuration
- **Action**: Ensure the EC2 instance is in a public subnet with a route to the Internet Gateway (IGW).
- **Verification**: The route table should have a `0.0.0.0/0` route to the IGW. Check if the instance has a public IP or Elastic IP.
- **Importance**: Without a public IP or IGW, external access won’t work.

## 5. Check DNS Configuration
- **Action**: Verify that the DNS record (probably in Route 53) points to the public IP of the TEST EC2 instance.
- **Verification**: Use `dig` or `nslookup` to check DNS resolution and wait for propagation if needed.
- **Importance**: DNS misconfigurations can cause the domain not to resolve to the correct public IP.

## 6. Application Status on EC2
- **Action**: SSH into the TEST EC2 and check if the application/web server is running on port 443.
- **Verification**: Use `netstat -tuln` or `ss -tuln` to see if port 443 is listening.
- **Importance**: If the app or web server isn’t running on 443, it won’t be accessible.

## 7. System Logs Check
- **Action**: Check logs like `/var/log/apache2/error.log` or `/var/log/nginx/error.log` for errors.
- **Importance**: Web server misconfigurations or issues with app deployments often show up in the logs.

## 8. SSL/TLS Configuration
- **Action**: Ensure the SSL/TLS certificates are configured correctly, not expired, and match the domain.
- **Verification**: Use `openssl s_client -connect <domain>:443` to verify the certificate.
- **Importance**: A wrong or expired SSL certificate will block HTTPS connections.

## 9. Test Connectivity
- **Action**: Use tools like `curl -v https://<domain>` or `telnet <public-ip> 443` to check connectivity.
- **Importance**: Helps identify if the connection is being blocked or timing out.

## 10. Check NAT Gateway (If Applicable)
- **Action**: If the EC2 instance uses a NAT Gateway for internet access, ensure the NAT is properly set up.
- **Verification**: Check the subnet route table and NAT Gateway configuration.
- **Importance**: Incorrect NAT setup can prevent outbound traffic from the instance.

## 11. Firewall and Inspection Policies
- **Action**: Ensure the **Checkpoint Firewall** or any other firewall allows inbound HTTPS traffic.
- **Importance**: Firewalls can block traffic even when VPC and instance configurations are correct.
