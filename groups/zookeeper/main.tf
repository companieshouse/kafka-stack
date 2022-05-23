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

module "zookeeper" {
  source = "git@github.com:companieshouse/terraform-modules//aws/kafka-zookeeper?ref=tags/1.0.139"

  ami_owner_id                = local.ami_owner_id
  cmak_access                 = local.cmak_access
  cmak_password               = local.cmak_password
  cmak_username               = local.cmak_username
  debug                       = var.debug
  default_ami_version_pattern = var.default_ami_version_pattern
  default_instance_type       = var.default_instance_type
  dns_zone_name               = local.dns_zone_name
  environment                 = var.environment
  instance_specifications     = var.instance_specifications
  lvm_block_definitions       = var.lvm_block_definitions
  prometheus_access           = local.prometheus_access
  root_volume_size_gib        = var.root_volume_size_gib
  route53_available           = var.route53_available
  service                     = var.service
  service_sub_type            = "zookeeper"
  ssh_access                  = local.ssh_access
  ssh_keyname                 = var.ssh_keyname
  subnets                     = local.placement_subnets_by_availability_zone
  team                        = var.team
  vpc_id                      = local.vpc_id
  zookeeper_client_access     = local.zookeeper_client_access
  zookeeper_heap_mb           = var.zookeeper_heap_mb
  zookeeper_peer_access       = local.zookeeper_peer_access
}
