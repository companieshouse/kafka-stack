output "debug" {
  value = var.debug ? {
    kafka_debug = module.kafka.debug
  } : {}
}

output "manual_steps" {
  value = {
    kafka = module.kafka.manual_steps
  }
}
