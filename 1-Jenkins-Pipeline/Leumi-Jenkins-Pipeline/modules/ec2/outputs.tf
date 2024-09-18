# path: Leumi-Jenkins-Pipeline/modules/ec2/outputs.tf

output "instance_id" {
  value = aws_instance.jenkins_server.id
}

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
