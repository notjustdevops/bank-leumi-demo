# path: Leumi-Jenkins-Pipeline/modules/jenkins/outputs.tf

output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
