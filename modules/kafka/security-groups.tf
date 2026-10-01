resource "aws_security_group" "kafka" {
  description = "Restricts access for ${var.service}-${var.environment} kafka nodes"
  name        = "${var.service}-${var.environment}-kafka"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Kafka client traffic"
    from_port       = var.kafka_port
    to_port         = var.kafka_port
    protocol        = "tcp"
    cidr_blocks     = var.kafka_broker_access.cidr_blocks
    prefix_list_ids = var.kafka_broker_access.list_ids
  }

  ingress {
    description = "Kafka KRaft internal traffic"
    from_port   = var.kafka_kraft_port
    to_port     = var.kafka_kraft_port
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description     = "Kafka KRaft traffic from trusted networks"
    from_port       = var.kafka_kraft_port
    to_port         = var.kafka_kraft_port
    protocol        = "tcp"
    cidr_blocks     = var.kafka_kraft_access.cidr_blocks
    prefix_list_ids = var.kafka_kraft_access.list_ids
  }

  ingress {
    description     = "Prometheus"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    cidr_blocks     = var.prometheus_access.cidr_blocks
    prefix_list_ids = var.prometheus_access.list_ids
  }

  ingress {
    description     = "Prometheus Kafka Exporter"
    from_port       = 9308
    to_port         = 9308
    protocol        = "tcp"
    cidr_blocks     = var.prometheus_access.cidr_blocks
    prefix_list_ids = var.prometheus_access.list_ids
  }

  ingress {
    description     = "Kafdrop UI from the load balancer"
    from_port       = var.kafdrop_port
    to_port         = var.kafdrop_port
    protocol        = "tcp"
    security_groups = [aws_security_group.kafdrop_load_balancer.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "${var.service}-${var.environment}-kafka"
    Environment    = var.environment
    Service        = var.service
    ServiceSubType = var.service_sub_type
    Team           = var.team
    Type           = "SecurityGroup"
  }
}

resource "aws_security_group" "kafdrop_load_balancer" {
  description = "Restricts access to the ${var.service}-${var.environment} kafdrop load balancer"
  name        = "${var.service}-${var.environment}-kafdrop-load-balancer"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Kafdrop UI"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = var.kafdrop_access.cidr_blocks
    prefix_list_ids = var.kafdrop_access.list_ids
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-${var.environment}-kafdrop"
    Environment = var.environment
    Service     = var.service
    Type        = "SecurityGroup"
  }
}