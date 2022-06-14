locals {
  ami_root_block_device = tolist(data.aws_ami.prometheus.block_device_mappings)[index(data.aws_ami.prometheus.block_device_mappings.*.device_name, data.aws_ami.prometheus.root_device_name)]
  ami_lvm_block_devices = [
    for block_device in data.aws_ami.prometheus.block_device_mappings :
      block_device if block_device.device_name != data.aws_ami.prometheus.root_device_name
  ]
  certificate_arn = var.route53_available ? aws_acm_certificate_validation.certificate[0].certificate_arn : var.certificate_arn
  debug = {}
  load_balancer_dns_name = "${var.service}-${var.environment}-prometheus.${var.load_balancer_dns_zone_name}"

  # ----------------------------------------------------------------------------

  manual_dns_entries = var.route53_available ? [] : [
    "${local.load_balancer_dns_name} -> ${aws_lb.prometheus.dns_name}"
  ]

  # ----------------------------------------------------------------------------

  manual_steps = {
    dns_entries = local.manual_dns_entries
  }

}
