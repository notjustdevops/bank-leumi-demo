# Fetch the latest Ubuntu AMI for the region
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Example for Ubuntu 20.04
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical's AWS account ID for official Ubuntu AMIs
}

# Create an EC2 instance using the dynamically fetched AMI ID
resource "aws_instance" "jenkins_instance" {
  ami           = data.aws_ami.ubuntu.id   # Use the fetched AMI ID here
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = merge(
    var.common_tags,
    { Name = "${var.resource_name_prefix}-ec2-instance" }
  )
}
