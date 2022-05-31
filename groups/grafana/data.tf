data "aws_ec2_managed_prefix_list" "administration" {
  name = "administration-cidr-ranges"
}

data "aws_key_pair" "kafka_stack" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }

  filter {
    name   = "tag:Service"
    values = [var.service]
  }
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "secrets" {
  path = "team-${var.team}/${var.account_name}/${var.region}/${var.environment}/${var.repository_name}"
}
