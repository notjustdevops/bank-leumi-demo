# NLB Setup

resource "aws_lb" "test_nlb" {
  name               = "${var.resource_name_prefix}-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = var.subnet_id
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}

resource "aws_lb_target_group" "test_nlb_target_group" {
  name     = "${var.resource_name_prefix}-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}

resource "aws_lb_listener" "test_nlb_listener" {
  load_balancer_arn = aws_lb.test_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_nlb_target_group.arn
  }

  tags = merge(var.common_tags, { Env = var.env_tag })
}
