# path: Leumi-Jenkins-Pipeline/modules/security/outputs.tf

output "security_group_id" {
  value = aws_security_group.jenkins_sg.id
}
