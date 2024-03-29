variable "ami_owner_id" {
  type        = string
  description = "The ID of the AMI owner"
}

variable "ami_version_pattern" {
  description = "The pattern with which to match AMIs"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate we'll use"
  type        = string
}

variable "debug" {
  description = "A flag indicating whether to output additional debug level information"
  type        = bool
}

variable "dns_zone_name" {
  description = "The name of the DNS zone we're using"
  type        = string
}

variable "email_from" {
  description = "The sender's email address used bt alertmanager"
  type        = string
}

variable "email_to" {
  description = "The email address alertmanager uses to send notifications to"
  type        = string
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "instance_count" {
  description = "The number of prometheus instances to provision"
  type        = number
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "load_balancer_dns_zone_name" {
  description = "The name of the DNS zone we're using for the load balancer"
  type        = string
}

variable "lvm_block_devices" {
  description = "A list of objects representing LVM block devices; each LVM volume group is assumed to contain a single physical volume and each logical volume is assumed to belong to a single volume group; the filesystem for each logical volume will be expanded to use all available space within the volume group using the filesystem resize tool specified; block device configuration applies only on resource creation"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "prometheus_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
    security_group_ids: []
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access to Prometheus"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
    security_group_ids: list(string)
  })
}

variable "prometheus_kafka_metrics_port" {
  description = "The metrics port to be used for Prometheus Kafka Exporter"
  type = string
}

variable "prometheus_metrics_port" {
  description = "The metrics port to be used"
  type = string
}

variable "prometheus_service_group" {
  description = "The Linux group name for association with prometheus configuration files"
  type        = string
}

variable "prometheus_service_user" {
  description = "The Linux username for ownership of prometheus configuration files"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "root_volume_size" {
  description = "The size of the root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed"
  type        = number
}

variable "route53_available" {
  description = "A flag indicating whether Route53 is available"
  type        = bool
}

variable "service" {
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "smarthost" {
  description = "The SMTP host through which emails are sent"
  type        = string
}

variable "smarthost_port" {
  description = "The SMTP hosts port number through which emails are sent"
  type        = string
}

variable "ssh_access" {
  default = {
    cidr_blocks: [],
    list_ids: [],
    security_group_ids: []
  }
  description = "An object defining CIDR blocks and prefix list ids controlling access to SSH"
  type = object({
    cidr_blocks: list(string),
    list_ids: list(string),
    security_group_ids: list(string)
  })
}

variable "ssh_keyname" {
  description = "The SSH keypair name to use for remote connectivity"
  type        = string
}

variable "subnet_ids" {
  description = "The ids of the subnets into which we'll place instances"
  type        = list(string)
}

variable "user_data_merge_strategy" {
  description = "Merge strategy to apply to user-data sections for cloud-init"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID in which to create resources"
  type        = string
}
