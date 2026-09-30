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
  source = "../../modules/kafka"

  ami_owner_id                    = local.ami_owner_id
  debug                           = var.debug
  default_ami_version_pattern     = var.default_ami_version_pattern
  default_instance_type           = var.default_instance_type
  dns_server_ip                   = local.dns_server_ip
  dns_zone_name                   = local.dns_zone_name
  ebs_kms_key_id                  = try(local.secrets.aws_ebs_kms_key_arn, null)
  environment                     = var.environment
  instance_specifications         = var.instance_specifications
  instance_template_path          = "${path.root}/instance-templates/kafka"
  kafka_broker_access             = local.kafka_broker_access
  kafka_kraft_access              = local.kafka_kraft_access
  lvm_block_definitions           = var.lvm_block_definitions
  ns_update_key_content           = local.ns_update_key_content
  prometheus_access               = local.prometheus_access
  root_volume_size_gib            = var.root_volume_size_gib
  route53_available               = var.route53_available
  service                         = var.service
  service_sub_type                = "kafka"
  ssm_kms_key                     = try(local.secrets.aws_ssm_kms_key_arn, null)
  stub_plan_mode                  = var.stub_plan_mode
  subnets                         = local.placement_subnets_by_availability_zone
  team                            = var.team
  vpc_id                          = local.vpc_id
}
