# path: Leumi-Jenkins-Pipeline/modules/jenkins/main.tf

resource "null_resource" "jenkins_setup" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = aws_instance.jenkins_server.public_ip
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y openjdk-11-jdk",
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }

  depends_on = [aws_instance.jenkins_server]
}
