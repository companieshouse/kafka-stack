data "aws_subnet" "automation" {
  provider = aws.development_eu_west_1

  for_each = data.aws_subnet_ids.automation.ids

  id = each.value
}

data "aws_subnet" "placement" {
  for_each = data.aws_subnet_ids.placement.ids
  id       = each.value
}


data "aws_subnet_ids" "automation" {
  provider = aws.development_eu_west_1

  vpc_id = data.aws_vpc.automation.id

  filter {
    name   = "tag:Name"
    values = [local.automation_subnet_pattern]
  }
}

data "aws_subnet_ids" "placement" {
  vpc_id = data.aws_vpc.placement.id

  filter {
    name = "tag:Name"
    values = local.placement_subnet_name_patterns
  }
}
