output "debug" {
  value = var.debug ? {
    zookeeper_debug = module.zookeeper.debug
  } : {}
}

output "manual_steps" {
  value = {
    zookeeper = module.zookeeper.manual_steps
  }
}
