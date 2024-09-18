# EC2 Outputs

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.test_ec2.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.test_ec2.id
}

output "security_group_id" {
  description = "ID of the security group attached to the EC2 instance"
  value       = aws_security_group.ec2_sg.id
}
