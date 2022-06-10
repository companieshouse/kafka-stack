locals {

  account_ids = data.vault_generic_secret.account_ids.data
  applications_subnets = values(data.aws_subnet.applications)
  automation_subnets = values(data.aws_subnet.automation)
  placement_subnets = values(data.aws_subnet.placement)
  placement_subnets_by_availability_zone = {
    for subnet in data.aws_subnet.placement : subnet.availability_zone => subnet
  }
  secrets = data.vault_generic_secret.secrets.data

  ssh_access = {
    cidr_blocks: [],
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
  }

  ssh_keyname = data.aws_key_pair.kafka_stack.key_name
  vpc_id = data.aws_vpc.placement.id

  zookeepers_by_availability_zone = {
    for availability_zone in toset(values(data.aws_instance.zookeepers).*.availability_zone) : availability_zone => sort([
      for instance in values(data.aws_instance.zookeepers) : instance.tags.HostName
        if instance.availability_zone == availability_zone
    ])
  }

  # ----------------------------------------------------------------------------

  ami_owner_id = local.secrets.kafka_ami_owner_id
  applications_subnet_pattern = local.secrets.applications_subnet_pattern
  applications_vpc_pattern = local.secrets.applications_vpc_pattern
  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern = local.secrets.automation_vpc_pattern

  bootstrap_zookeepers = [
    for instances in values(local.zookeepers_by_availability_zone) : instances[0]
      if length(instances) > 0
  ]

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

  kafka_zookeeper_connect_string = join(",", formatlist("%s:2181", local.bootstrap_zookeepers))

  placement_subnet_cidrs = values(zipmap(
    local.placement_subnets.*.availability_zone,
    local.placement_subnets.*.cidr_block
  ))

  # ----------------------------------------------------------------------------

  debug = {}

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

  prometheus_access = {
    cidr_blocks: concat(
      local.placement_subnet_cidrs
    )
    list_ids: []
  }

}
