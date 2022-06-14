output "debug" {
  value = var.debug ? {
    prometheus_debug = module.prometheus.debug
  } : {}
}

output "manual_steps" {
  value = {
    prometheus = module.prometheus.manual_steps
  }
}
