resource "aws_acm_certificate" "certificate" {
  count                     = var.route53_available ? 1 : 0

  domain_name               = "${var.service}-${var.environment}-prometheus.${var.load_balancer_dns_zone_name}"
  subject_alternative_names = ["*.${var.service}-${var.environment}-prometheus.${var.load_balancer_dns_zone_name}"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "certificate" {
  count                   = var.route53_available ? 1 : 0

  certificate_arn         = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = [aws_route53_record.certificate_validation[0].fqdn]
}

resource "aws_lb" "prometheus" {
  name                       = "${var.service}-${var.environment}-prometheus"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.prometheus_load_balancer.id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    Service     = var.service
    Name        = "${var.service}-${var.environment}-prometheus"
    Type        = "ApplicationLoadBalancer"
  }
}

resource "aws_lb_target_group" "prometheus" {
  name        = "${var.service}-${var.environment}-prometheus"
  port        = 9090
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/graph"
    interval            = 60
  }
}

resource "aws_lb_target_group" "alertmanager" {
  name        = "${var.service}-${var.environment}-alertmanager"
  port        = 9093
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/alertmanager/"
    interval            = 60
  }
}

resource "aws_lb_target_group_attachment" "prometheus" {
  count            = var.instance_count

  target_group_arn = aws_lb_target_group.prometheus.arn
  target_id        = element(aws_instance.prometheus.*.private_ip, count.index)
  port             = 9090
}

resource "aws_lb_target_group_attachment" "alertmanager" {
  count            = var.instance_count

  target_group_arn = aws_lb_target_group.alertmanager.arn
  target_id        = element(aws_instance.prometheus.*.private_ip, count.index)
  port             = 9093
}

resource "aws_lb_listener" "prometheus" {
  load_balancer_arn = aws_lb.prometheus.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = local.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus.arn
  }

  depends_on = [
    aws_acm_certificate_validation.certificate
  ]
}

resource "aws_lb_listener_rule" "alertmanager_rule1" {
  listener_arn = aws_lb_listener.prometheus.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alertmanager.arn
  }
  condition {
    path_pattern {
      values = [
        "*/alertmanager/*"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "alertmanager_rule2" {
  listener_arn = aws_lb_listener.prometheus.arn
  action {
    type  = "redirect"
    redirect {
      path = "/alertmanager/"
      status_code = "HTTP_301"
    }
  }
  condition {
    path_pattern {
      values = [
        "/alertmanager"
      ]
    }
  }
}
