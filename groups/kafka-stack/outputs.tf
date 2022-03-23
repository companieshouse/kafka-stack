output "manual_steps" {
  value = {
    kafka = module.kafka.manual_steps
    zookeeper = module.zookeeper.manual_steps
  }
}
