# path: /home/notjust/Documents/devops/Projects/bank-leumi-demo/1-Jenkins-Pipeline/modules/ec2/outputs.tf

output "jenkins_instance_id" {
  description = "The ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_instance.id
}

output "jenkins_instance_public_ip" {
  description = "The public IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_instance.public_ip
}

output "jenkins_key_pair_name" {
  description = "The key pair name used by Jenkins EC2 instance"
  value       = aws_key_pair.jenkins_key_pair.key_name
}
