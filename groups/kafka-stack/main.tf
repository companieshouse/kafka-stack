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
  source = "git@github.com:companieshouse/terraform-modules//aws/kafka?ref=tags/1.0.118"

  ami_owner_id                    = local.kafka_ami_owner_id
  ami_version_pattern             = var.kafka_ami_version_pattern
  dns_zone_name                   = local.dns_zone_name
  environment                     = var.environment
  instance_count                  = var.kafka_instance_count
  instance_type                   = var.kafka_instance_type
  kafka_broker_access             = local.kafka_broker_access
  kafka_zookeeper_connect_string  = local.kafka_zookeeper_connect_string
  lvm_block_definitions           = var.kafka_lvm_block_definitions
  root_volume_size_gib            = var.kafka_root_volume_size_gib
  route53_available               = var.route53_available
  service                         = var.service
  service_sub_type                = "kafka"
  ssh_access                      = local.ssh_access
  ssh_keyname                     = var.ssh_keyname
  subnet_ids                      = local.placement_subnet_ids
  team                            = var.team
  vpc_id                          = local.vpc_id

  depends_on = [
    module.zookeeper
  ]
}

module "zookeeper" {
  source = "git@github.com:companieshouse/terraform-modules//aws/zookeeper?ref=tags/1.0.118"

  ami_owner_id            = local.zookeeper_ami_owner_id
  ami_version_pattern     = var.zookeeper_ami_version_pattern
  dns_zone_name           = local.dns_zone_name
  environment             = var.environment
  instance_count          = var.zookeeper_instance_count
  instance_type           = var.zookeeper_instance_type
  lvm_block_definitions   = var.zookeeper_lvm_block_definitions
  root_volume_size_gib    = var.zookeeper_root_volume_size_gib
  route53_available       = var.route53_available
  service                 = var.service
  service_sub_type        = "zookeeper"
  ssh_access              = local.ssh_access
  ssh_keyname             = var.ssh_keyname
  subnet_ids              = local.placement_subnet_ids
  team                    = var.team
  vpc_id                  = local.vpc_id
  zookeeper_client_access = local.zookeeper_client_access
  zookeeper_peer_access   = local.zookeeper_peer_access
}
