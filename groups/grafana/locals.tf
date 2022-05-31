locals {

  account_ids = data.vault_generic_secret.account_ids.data

  automation_subnet_cidrs = values(zipmap(
    values(data.aws_subnet.automation).*.availability_zone,
    values(data.aws_subnet.automation).*.cidr_block
  ))

  placement_subnet_ids = values(zipmap(
    values(data.aws_subnet.placement).*.availability_zone,
    values(data.aws_subnet.placement).*.id
  ))

  secrets = data.vault_generic_secret.secrets.data

  ssh_access = {
    cidr_blocks: [],
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ],
    security_group_ids: []
  }

  ssh_keyname = data.aws_key_pair.kafka_stack.key_name

  # ----------------------------------------------------------------------------

  automation_subnet_pattern = local.secrets.automation_subnet_pattern
  automation_vpc_pattern = local.secrets.automation_vpc_pattern
  certificate_arn = lookup(local.secrets, "certificate_arn", null)
  dns_zone_name = local.secrets.dns_zone_name
  grafana_admin_password = local.secrets.grafana_admin_password
  ldap_auth_bind_dn = local.secrets.ldap_auth_bind_dn
  ldap_auth_bind_password = local.secrets.ldap_auth_bind_password
  ldap_auth_host = local.secrets.ldap_auth_host
  ldap_auth_port = local.secrets.ldap_auth_port
  ldap_auth_search_base_dns = local.secrets.ldap_auth_search_base_dns
  ldap_auth_search_filter = local.secrets.ldap_auth_search_filter
  ldap_grafana_admin_group_dn = local.secrets.ldap_grafana_admin_group_dn
  ldap_grafana_viewer_group_dn = local.secrets.ldap_grafana_viewer_group_dn
  placement_subnet_name_patterns = jsondecode(local.secrets.placement_subnet_name_patterns)
  placement_vpc_pattern = local.secrets.placement_vpc_pattern
  route53_available = local.secrets.route53_available

  # ----------------------------------------------------------------------------

  grafana_access = {
    cidr_blocks: concat(
      local.automation_subnet_cidrs,
    )
    list_ids: [
      data.aws_ec2_managed_prefix_list.administration.id
    ]
    security_group_ids: []
  }

}
