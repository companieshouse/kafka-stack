output "brokers" {
  description = "A list of the Kafka broker connection strings for convenience"
  value       = formatlist("%s:${var.kafka_port}", values(local.instance_definitions).*.hostname)
}

output "kafdrop_url" {
  description = "The URL of the Kafdrop UI"
  value       = "https://${local.kafdrop_load_balancer_dns_name}"
}

output "instance_ips" {
  description = "The ips of the provisioned hosts"
  value       = values(aws_instance.kafkas).*.private_ip
}

output "instance_profile" {
  description = "The IAM instance profile used by Kafka brokers"
  value       = module.instance_profile.aws_iam_instance_profile.name
}

output "debug" {
  description = "Additional output for debugging"
  value       = var.debug ? local.debug : {}
}

output "manual_steps" {
  description = "A map of any manual steps that need to be carried out"
  value       = local.manual_steps
}