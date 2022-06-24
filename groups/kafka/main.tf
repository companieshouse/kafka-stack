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

module "kafka" {
  source = "git@github.com:companieshouse/terraform-modules//aws/kafka?ref=tags/1.0.162"

  ami_owner_id                    = local.ami_owner_id
  debug                           = var.debug
  default_ami_version_pattern     = var.default_ami_version_pattern
  default_instance_type           = var.default_instance_type
  dns_server_ip                   = local.dns_server_ip
  dns_zone_name                   = local.dns_zone_name
  environment                     = var.environment
  instance_specifications         = var.instance_specifications
  instance_template_path          = "${path.root}/instance-templates/kafka"
  kafka_broker_access             = local.kafka_broker_access
  kafka_zookeeper_connect_string  = local.kafka_zookeeper_connect_string
  lvm_block_definitions           = var.lvm_block_definitions
  ns_update_key_content           = local.ns_update_key_content
  prometheus_access               = local.prometheus_access
  root_volume_size_gib            = var.root_volume_size_gib
  route53_available               = var.route53_available
  service                         = var.service
  service_sub_type                = "kafka"
  ssh_access                      = local.ssh_access
  ssh_keyname                     = local.ssh_keyname
  subnets                         = local.placement_subnets_by_availability_zone
  team                            = var.team
  vpc_id                          = local.vpc_id
}
