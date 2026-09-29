module "instance_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.162"

  name = "${var.service}-${var.environment}-kafka"
}

resource "aws_instance" "kafkas" {
  for_each = local.instance_definitions

  ami                    = data.aws_ami.kafkas[each.value.ami_version_pattern].id
  iam_instance_profile   = module.instance_profile.aws_iam_instance_profile.name
  instance_type          = each.value.instance_type
  subnet_id              = var.subnets[each.value.availability_zone].id
  user_data_base64       = data.cloudinit_config.kafkas[each.key].rendered
  vpc_security_group_ids = [aws_security_group.kafka.id]

  root_block_device {
    encrypted   = true
    kms_key_id  = var.ebs_kms_key_id
    volume_size = var.root_volume_size_gib
  }

  dynamic "ebs_block_device" {
    for_each = local.ami_lvm_block_devices[each.value.ami_version_pattern]
    iterator = block_device

    content {
      device_name = block_device.value.device_name
      encrypted   = true
      iops        = block_device.value.ebs.iops
      kms_key_id  = var.ebs_kms_key_id
      snapshot_id = block_device.value.ebs.snapshot_id
      volume_size = var.lvm_block_definitions[index(var.lvm_block_definitions.*.lvm_physical_volume_device_node, block_device.value.device_name)].aws_volume_size_gb
      volume_type = block_device.value.ebs.volume_type
    }
  }

  tags = {
    Environment     = var.environment
    HostName        = each.value.hostname
    Name            = each.value.name
    Service         = var.service
    ServiceSubType  = var.service_sub_type
    Team            = var.team
  }

}
