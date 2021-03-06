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

  ssh_keyname = data.aws_key_pair.kafka_stack.key_name

  vpc_id = data.aws_vpc.placement.id

  # ----------------------------------------------------------------------------

  ami_owner_id = local.secrets.zookeeper_ami_owner_id
  certificate_arn = lookup(local.secrets, "certificate_arn", null)
  cmak_basic_authentication = contains(keys(local.secrets), "cmak_basic_authentication") ? jsondecode(local.secrets.cmak_basic_authentication) : var.cmak_basic_authentication
  dns_server_ip = local.secrets.dns_server_ip
  dns_zone_name = local.secrets.dns_zone_name
  load_balancer_dns_zone_name = local.secrets.load_balancer_dns_zone_name
  ns_update_key_content = local.secrets.ns_update_key_content
  placement_subnet_pattern = local.secrets.placement_subnet_pattern
  placement_vpc_pattern = local.secrets.placement_vpc_pattern

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
    list_ids: var.allow_prometheus_administration_access ? [
      data.aws_ec2_managed_prefix_list.administration.id
    ] : []
  }

  zookeeper_client_access = {
    cidr_blocks: local.placement_subnet_cidrs,
    list_ids: var.allow_client_administration_access ? [
      data.aws_ec2_managed_prefix_list.administration.id
    ] : []
  }

  zookeeper_peer_access = {
    cidr_blocks: local.placement_subnet_cidrs,
    list_ids: [],
  }

}
