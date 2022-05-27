variable "account_name" {
  description = "The name of the AWS account we're using"
  type        = string
}

variable "debug" {
  default     = false
  description = "A flag indicating whether to output additional debug level information"
  type        = bool
}

variable "environment" {
  description = "The environment name to be used when creating AWS resources"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be created"
  type        = string
}

variable "repository_name" {
  default     = "kafka-stack"
  description = "The name of the repository in which we're operating"
  type        = string
}

variable "route53_available" {
  description = "A flag indicating whether Route53 is available"
  type        = bool
}

variable "service" {
  default     = "kafka3"
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "ssh_keyname" {
  description = "The SSH keypair name to use for remote connectivity"
  type        = string
}

variable "team" {
  default     = "platform"
  description = "The team responsible for administering the instance"
  type        = string
}

variable "default_ami_version_pattern" {
  default =   "\\d.\\d.\\d"
  description = "The default AMI version pattern to use when matching AMIs for instances"
  type        = string
}

variable "default_instance_type" {
  default     = "t3.medium"
  description = "The default instance type to use for instances"
  type        = string
}

variable "zookeeper_heap_mb" {
  default     = 512
  description = "The heap memory in MB to assign"
  type        = number
}

variable "instance_specifications" {
  description = "A map of specifications for the instances"
  type = map(map(map(string)))
}

variable "lvm_block_definitions" {
  default = [
    {
      aws_volume_size_gb: "50",
      filesystem_resize_tool: "xfs_growfs",
      lvm_logical_volume_device_node: "/dev/zookeeper/data",
      lvm_physical_volume_device_node: "/dev/xvdb"
    }
  ]
  description = "Zookeeper LVM block definitions"
  type = list(object({
    aws_volume_size_gb: string,
    filesystem_resize_tool: string,
    lvm_logical_volume_device_node: string,
    lvm_physical_volume_device_node: string,
  }))
}

variable "root_volume_size_gib" {
  default     = 50
  description = "The size of the zookeeper root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed"
  type        = number
}
