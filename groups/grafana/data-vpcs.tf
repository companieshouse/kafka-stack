data "aws_vpc" "automation" {
  provider = aws.development_eu_west_1

  filter {
    name   = "tag:Name"
    values = [local.automation_vpc_pattern]
  }
}

data "aws_vpc" "placement" {
  filter {
    name   = "tag:Name"
    values = [local.placement_vpc_pattern]
  }
}
