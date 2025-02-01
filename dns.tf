data "aws_route53_zone" "selected_zone" {
  name = "${var.aws_profile}.${var.domain_name}"
}

# Create or update the A record for the subdomain (dev or demo)
resource "aws_route53_record" "lb_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = "${var.aws_profile}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}

#Add Route 53 DNS validation records for the ACM certificate.
resource "aws_route53_record" "dev_ssl_cert_validation" {
  for_each = var.aws_profile == var.aws_dev_profile ? {
    for dvo in aws_acm_certificate.dev_ssl_cert[0].domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  } : {}

  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]

}

