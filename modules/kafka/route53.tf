resource "aws_route53_record" "kafka" {
  for_each = var.route53_available ? local.instance_definitions : {}

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = each.value.hostname
  type    = "A"
  ttl     = "300"
  records = [aws_instance.kafkas[each.key].private_ip]
}

resource "aws_route53_record" "kafdrop_certificate_validation" {
  count = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = tolist(aws_acm_certificate.kafdrop[0].domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.kafdrop[0].domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.kafdrop[0].domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "kafdrop_load_balancer" {
  count = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = local.kafdrop_load_balancer_dns_name
  type    = "A"

  alias {
    name                   = aws_lb.kafdrop.dns_name
    zone_id                = aws_lb.kafdrop.zone_id
    evaluate_target_health = false
  }
}