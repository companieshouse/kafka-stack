output "debug" {
  value = var.debug ? {
    kafka_debug = module.kafka.debug
    zookeeper_debug = module.zookeeper.debug
  } : {}
}

output "manual_steps" {
  value = {
    kafka = module.kafka.manual_steps
    zookeeper = module.zookeeper.manual_steps
  }
}
