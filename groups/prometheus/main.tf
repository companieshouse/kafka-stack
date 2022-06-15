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

module "prometheus" {
  source = "./module-prometheus"

  ami_owner_id                  = var.ami_owner_id
  ami_version_pattern           = var.prometheus_ami_version_pattern
  certificate_arn               = local.certificate_arn
  debug                         = var.debug
  dns_zone_name                 = local.dns_zone_name
  environment                   = var.environment
  instance_count                = var.prometheus_instance_count
  instance_type                 = var.prometheus_instance_type
  load_balancer_dns_zone_name   = local.load_balancer_dns_zone_name
  prometheus_access             = local.prometheus_access
  prometheus_service_group      = var.prometheus_service_group
  prometheus_service_user       = var.prometheus_service_user
  lvm_block_devices             = var.prometheus_lvm_block_devices
  prometheus_kafka_metrics_port = var.prometheus_kafka_metrics_port
  prometheus_metrics_port       = var.prometheus_metrics_port
  region                        = var.region
  root_volume_size              = var.prometheus_root_volume_size
  route53_available             = local.route53_available
  service                       = var.service
  ssh_access                    = local.ssh_access
  ssh_keyname                   = local.ssh_keyname
  subnet_ids                    = local.placement_subnet_ids
  user_data_merge_strategy      = var.user_data_merge_strategy
  vpc_id                        = data.aws_vpc.placement.id
}
