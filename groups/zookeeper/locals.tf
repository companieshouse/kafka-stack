locals {

  cmak_access = {
    cidr_blocks: [],
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
  }

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

  vpc_id = data.aws_vpc.placement.id

  # ----------------------------------------------------------------------------

  cmak_password = local.secrets.cmak_password
  cmak_username = local.secrets.cmak_username
  dns_server_ip = local.secrets.dns_server_ip
  dns_zone_name = local.secrets.dns_zone_name
  ns_update_key_content = local.secrets.ns_update_key_content
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern = local.secrets.placement_vpc_pattern
  ami_owner_id = local.secrets.zookeeper_ami_owner_id

  # ----------------------------------------------------------------------------

  placement_subnet_cidrs = values(zipmap(
    local.placement_subnets.*.availability_zone,
    local.placement_subnets.*.cidr_block
  ))

  # ----------------------------------------------------------------------------

  debug = {}

  prometheus_access = {
    cidr_blocks: concat(
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
