locals {

  account_ids = data.vault_generic_secret.account_ids.data
  applications_subnets = values(data.aws_subnet.applications)
  automation_subnets = values(data.aws_subnet.automation)
  placement_subnets = values(data.aws_subnet.placement)
  placement_subnets_by_availability_zone = {
    for subnet in data.aws_subnet.placement : subnet.availability_zone => subnet
  }
  secrets = data.vault_generic_secret.secrets.data
  vpc_id = data.aws_vpc.placement.id

  # ----------------------------------------------------------------------------

  ami_owner_id = local.secrets.kafka_ami_owner_id
  applications_subnet_pattern = local.secrets.applications_subnet_pattern
  applications_vpc_pattern = local.secrets.applications_vpc_pattern
  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern = local.secrets.automation_vpc_pattern

  dns_server_ip = local.secrets.dns_server_ip
  dns_zone_name = local.secrets.dns_zone_name
  ns_update_key_content = local.secrets.ns_update_key_content
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern = local.secrets.placement_vpc_pattern

  # ----------------------------------------------------------------------------

  applications_subnet_cidrs = values(zipmap(
    local.applications_subnets.*.availability_zone,
    local.applications_subnets.*.cidr_block
  ))

  automation_subnet_cidrs = values(zipmap(
    local.automation_subnets.*.availability_zone,
    local.automation_subnets.*.cidr_block
  ))

  placement_subnet_cidrs = values(zipmap(
    local.placement_subnets.*.availability_zone,
    local.placement_subnets.*.cidr_block
  ))

  broker_automation_access_list_ids = var.allow_broker_automation_access ? [data.aws_ec2_managed_prefix_list.automation.id] : []
  broker_admin_access_list_ids = var.allow_broker_administration_access ? [data.aws_ec2_managed_prefix_list.administration.id] : []

  # ----------------------------------------------------------------------------

  debug = {}

  kafka_broker_access = {
    cidr_blocks: concat(
      local.applications_subnet_cidrs,
      var.allow_broker_automation_access ? local.automation_subnet_cidrs : [],
      local.placement_subnet_cidrs
    )
    list_ids: concat(local.broker_automation_access_list_ids, local.broker_admin_access_list_ids)
  }

  kafka_kraft_access = {
    cidr_blocks: local.placement_subnet_cidrs
    list_ids: []
  }

  prometheus_access = {
    cidr_blocks: concat(
      local.placement_subnet_cidrs
    )
    list_ids: var.allow_prometheus_administration_access ? [
      data.aws_ec2_managed_prefix_list.administration.id
    ] : []
  }

}
