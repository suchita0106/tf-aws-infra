
# Only keep the HTTPS Listener
resource "aws_lb_listener" "app_https_listener" {
  count             = var.aws_profile == var.aws_dev_profile ? 1 : 0
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.dev_ssl_cert[0].arn # Replace with demo cert ARN for demo environment

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}


# ACM Certificate for Dev Environment
resource "aws_acm_certificate" "dev_ssl_cert" {
  count             = var.aws_profile == var.aws_dev_profile ? 1 : 0
  domain_name       = "${var.aws_dev_profile}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "Dev SSL Certificate"
  }
}

data "aws_acm_certificate" "imported_cert" {
  count       = var.aws_profile == var.aws_demo_profile ? 1 : 0
  domain      = var.demo_domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# Listener for Demo Environment using Imported Certificate
resource "aws_lb_listener" "app_https_listener_demo" {
  count             = var.aws_profile == var.aws_demo_profile ? 1 : 0
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.imported_cert[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = {
    Name = "Demo HTTPS Listener"
  }
}
