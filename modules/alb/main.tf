provider "aws" {}

resource "aws_lb" "app_lb" {
  name = "${var.name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = var.security_groups
  subnets = var.subnets

//  enable_deletion_protection = true

  tags = merge({
    Name = "${var.name}-alb"
  },
  var.tags
  )
}

resource "aws_lb_target_group" "aws_target_group" {
  name     = "${var.name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_target_group.arn
  }
}


resource "aws_lb_listener" "https_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.ec2_instances)
  target_group_arn = aws_lb_target_group.aws_target_group.arn
  target_id        = element(var.ec2_instances, count.index)
  port             = 80
}