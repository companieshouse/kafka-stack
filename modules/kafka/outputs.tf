output "brokers" {
  description = "A list of the Kafka broker connection strings for convenience"
  value       = formatlist("%s:${var.kafka_port}", values(local.instance_definitions).*.hostname)
}

output "instance_ips" {
  description = "The ips of the provisioned hosts"
  value       = values(aws_instance.kafkas).*.private_ip
}

output "instance_profile" {
  description = "The IAM instance profile used by Kafka brokers"
  value       = var.stub_plan_mode ? null : module.instance_profile[0].aws_iam_instance_profile.name
}

output "debug" {
  description = "Additional output for debugging"
  value       = var.debug ? local.debug : {}
}

output "manual_steps" {
  description = "A map of any manual steps that need to be carried out"
  value       = local.manual_steps
}
