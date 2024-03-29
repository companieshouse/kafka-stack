data "template_cloudinit_config" "prometheus" {
  count         = var.instance_count

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/system-config.yml.tpl", {
      instance_fqdn = "${var.service}-${var.environment}-prometheus-${count.index + 1}.${var.dns_zone_name}"
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type                    = "text/cloud-config"
    content                         = templatefile("${path.module}/cloud-init/templates/alertmanager.yml.tpl", {
      email_from      = var.email_from
      email_to        = var.email_to
      smarthost       = var.smarthost
      smarthost_port  = var.smarthost_port
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type                    = "text/cloud-config"
    content                         = templatefile("${path.module}/cloud-init/templates/alertmanager.service.tpl", {
      environment                 = var.environment
      load_balancer_dns_zone_name = var.load_balancer_dns_zone_name
      service                     = var.service

    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type                    = "text/cloud-config"
    content                         = templatefile("${path.module}/cloud-init/templates/prometheus.yml.tpl", {
      environment                   = var.environment
      prometheus_kafka_metrics_port = var.prometheus_kafka_metrics_port
      prometheus_metrics_port       = var.prometheus_metrics_port
      region                        = var.region
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type    = "text/cloud-config"
    content         =  templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
      lvm_block_devices       = var.lvm_block_devices
      root_volume_device_node = data.aws_ami.prometheus.root_device_name
    })
  }
}
