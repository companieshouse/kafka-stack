output "debug" {
  value = var.debug ? {
    grafana_debug = module.grafana.debug
  } : {}
}

output "manual_steps" {
  value = {
    grafana = module.grafana.manual_steps
  }
}
