locals {

  account_ids = data.vault_generic_secret.account_ids.data
  applications_subnets = values(data.aws_subnet.applications)
  automation_subnets = values(data.aws_subnet.automation)
  kafka_zookeeper_connect_string = join(",", formatlist("%s:2181", module.zookeeper.instance_ips))
  placement_subnets = values(data.aws_subnet.placement)
  secrets = data.vault_generic_secret.secrets.data

  ssh_access = {
    cidr_blocks: [],
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
  }

  vpc_id = data.aws_vpc.placement.id

  # ----------------------------------------------------------------------------

  applications_subnet_pattern = local.secrets.applications_subnet_pattern
  applications_vpc_pattern = local.secrets.applications_vpc_pattern
  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern = local.secrets.automation_vpc_pattern
  dns_zone_name = local.secrets.dns_zone_name
  kafka_ami_owner_id = local.secrets.kafka_ami_owner_id
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern = local.secrets.placement_vpc_pattern
  zookeeper_ami_owner_id = local.secrets.zookeeper_ami_owner_id

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

  placement_subnet_ids = values(zipmap(
    local.placement_subnets.*.availability_zone,
    local.placement_subnets.*.id
  ))

  # ----------------------------------------------------------------------------

  kafka_broker_access = {
    cidr_blocks: concat(
      local.applications_subnet_cidrs,
      local.automation_subnet_cidrs,
      local.placement_subnet_cidrs
    )
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
  }

  zookeeper_client_access = {
    cidr_blocks: local.placement_subnet_cidrs,
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
  }

  zookeeper_peer_access = {
    cidr_blocks: local.placement_subnet_cidrs,
    list_ids: [],
  }

}
