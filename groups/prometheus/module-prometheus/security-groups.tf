resource "aws_security_group" "prometheus" {
  description = "Restricts access to prometheus ${var.service} instances"
  name = "${var.service}-${var.environment}-prometheus"
  vpc_id = var.vpc_id

  ingress {
    description     = "Inbound SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ssh_access.cidr_blocks
    prefix_list_ids = var.ssh_access.list_ids
    security_groups = var.ssh_access.security_group_ids
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    security_groups = [
      aws_security_group.prometheus_load_balancer.id
    ]
  }

  ingress {
    description = "alertmanager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    security_groups = [
      aws_security_group.prometheus_load_balancer.id
    ]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-prometheus"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}

resource "aws_security_group" "prometheus_load_balancer" {
  description = "Restricts access to the prometheus load balancer"
  name = "${var.service}-${var.environment}-prometheus-load-balancer"
  vpc_id = var.vpc_id

  ingress {
    description = "Prometheus"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = var.prometheus_access.cidr_blocks
    prefix_list_ids = var.prometheus_access.list_ids
    security_groups = var.prometheus_access.security_group_ids
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-prometheus"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}
