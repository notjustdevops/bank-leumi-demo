# path: Leumi-Jenkins-Pipeline/modules/ec2/instance.tf

resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.public_subnet_id

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-jenkins-server" })
}
