# path: Leumi-Jenkins-Pipeline/modules/ecr/main.tf

resource "aws_ecr_repository" "python_app" {
  name                 = "${var.resource_name_prefix}-ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.common_tags, { Name = "${var.resource_name_prefix}-ecr" })
}
