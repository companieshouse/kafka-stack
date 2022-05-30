terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
  }
  backend "s3" {}
}

resource "aws_key_pair" "kafka_stack" {
  key_name   = "${var.service}-${var.environment}"
  public_key = local.ssh_public_key

  tags = {
    Environment = var.environment
    Service     = var.service
  }
}
