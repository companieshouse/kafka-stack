# kafka

## Overview

Creates an Apache [Kafka](https://kafka.apache.org/) KRaft broker cluster.

This module provisions:

- three broker EC2 instances across three availability zones (validated)
- Kafka 4.2 AMI lookup
- SSM-enabled instance profile (no SSH key usage)
- encrypted root and LVM data volumes
- Kafka, KRaft and Prometheus security group rules
- optional Route53 records using the `route53_available` pattern
- cloud-init based runtime configuration for Kafka and host bootstrap

## Usage

```hcl
module "kafka" {
  source = "git@github.com:companieshouse/terraform-modules//aws/kafka?ref=tags/1.0.287"

  ami_owner_id                 = "123456789012"
  debug                        = false
  default_ami_version_pattern  = "4.2.*"
  default_instance_type        = "m6i.large"
  dns_server_ip                = "10.0.0.2"
  dns_zone_name                = "example.internal"
  environment                  = "development"

  instance_specifications = {
    eu-west-2a = {
      "1" = {}
    }
    eu-west-2b = {
      "2" = {}
    }
    eu-west-2c = {
      "3" = {}
    }
  }

  kafka_broker_access = {
    cidr_blocks = ["10.0.0.0/8"]
    list_ids    = []
  }

  kafka_kraft_access = {
    cidr_blocks = []
    list_ids    = []
  }

  lvm_block_definitions = [
    {
      aws_volume_size_gb             = "100"
      filesystem_resize_tool         = "xfs_growfs"
      lvm_logical_volume_device_node = "/dev/kafka/data"
      lvm_physical_volume_device_node = "/dev/xvdb"
    }
  ]

  ns_update_key_content = "<redacted>"

  prometheus_access = {
    cidr_blocks = ["10.0.0.0/8"]
    list_ids    = []
  }

  root_volume_size_gib = 50
  route53_available    = true
  service              = "kafka"
  service_sub_type     = "broker"
  subnets              = {
    eu-west-2a = { id = "subnet-aaaaaaaa" }
    eu-west-2b = { id = "subnet-bbbbbbbb" }
    eu-west-2c = { id = "subnet-cccccccc" }
  }
  team                 = "platform"
  vpc_id               = "vpc-xxxxxxxx"
}
```

## Caveats

This module intentionally validates two inputs strictly to enforce the expected Kafka broker layout and storage pattern.

### 1) `instance_specifications` must define exactly three brokers across exactly three AZs

Validation in `variables.tf` enforces:

- exactly three availability-zone keys
- exactly three broker entries in total

This means each broker should be placed in a different AZ.

This passes:

```hcl
instance_specifications = {
  eu-west-2a = { "1" = {} }
  eu-west-2b = { "2" = {} }
  eu-west-2c = { "3" = {} }
}
```

This fails:

```hcl
instance_specifications = {
  eu-west-2a = { "1" = {}, "2" = {} }
  eu-west-2b = { "3" = {} }
}
```

Reason: only two AZ keys are provided.

### 2) `lvm_block_definitions` must include `/dev/xvdb`

Validation in `variables.tf` enforces at least one LVM physical device entry for `/dev/xvdb`.

This passes:

```hcl
lvm_block_definitions = [
  {
    aws_volume_size_gb              = "100"
    filesystem_resize_tool          = "xfs_growfs"
    lvm_logical_volume_device_node  = "/dev/kafka/data"
    lvm_physical_volume_device_node = "/dev/xvdb"
  }
]
```

This fails:

```hcl
lvm_block_definitions = [
  {
    aws_volume_size_gb              = "100"
    filesystem_resize_tool          = "xfs_growfs"
    lvm_logical_volume_device_node  = "/dev/kafka/data"
    lvm_physical_volume_device_node = "/dev/xvdc"
  }
]
```

Reason: no `/dev/xvdb` entry is present.

These checks fail at Terraform input validation time, so misconfigurations are caught before resource creation.

## Requirements

| Name      | Version         |
| --------- | --------------- |
| terraform | >= 0.13, < 0.14 |

## Providers

| Name | Version         |
| ---- | --------------- |
| aws  | >= 3.0, < 4.0   |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ami_owner_id | The ID of the AMI owner | `string` | n/a | yes |
| aws_instance_metadata_url | The URL comprising protocol and link-local IP address for retrieving instance metadata | `string` | `http://169.254.169.254` | no |
| debug | A flag indicating whether to output additional debug level information | `bool` | n/a | yes |
| default_ami_version_pattern | The default Kafka 4.2 AMI version pattern to use when matching AMIs | `string` | n/a | yes |
| default_instance_type | The default instance type | `string` | n/a | yes |
| dns_server_ip | The IP address of the DNS server to use and update | `string` | n/a | yes |
| dns_zone_name | The name of the DNS zone we're using | `string` | n/a | yes |
| environment | The environment name to be used when creating AWS resources | `string` | n/a | yes |
| ebs_kms_key_id | Optional KMS key ID or alias to use for encrypting root and data EBS volumes | `string` | `null` | no |
| instance_specifications | A map of specifications for the instances. Must define exactly three brokers across exactly three availability zones. | `map(map(map(string)))` | n/a | yes |
| instance_template_path | The path for any instance specific templates | `string` | `null` | no |
| kafka_broker_access | An object defining CIDR blocks and prefix list ids controlling access to kafka brokers | `object({ cidr_blocks = list(string), list_ids = list(string) })` | `{ cidr_blocks = [], list_ids = [] }` | no |
| kafka_data_directory | The location where Kafka will store it's data | `string` | `/data/kafka` | no |
| kafka_home | The home directory of the kafka installation | `string` | `/opt/kafka` | no |
| kafka_kraft_access | An object defining CIDR blocks and prefix list ids controlling additional access to the KRaft controller listener | `object({ cidr_blocks = list(string), list_ids = list(string) })` | `{ cidr_blocks = [], list_ids = [] }` | no |
| kafka_kraft_port | The port used for internal KRaft controller traffic | `number` | `9093` | no |
| kafka_min_insync_replicas | The value for the min.insync.replicas Kafka property | `number` | `2` | no |
| kafka_offsets_topic_replication_factor | The value for the offsets.topic.replication.factor Kafka property | `number` | `3` | no |
| kafka_port | The port on which kafka listens for clients | `number` | `9092` | no |
| kafka_service_group | The Linux group name for association with configuration files | `string` | `kafka` | no |
| kafka_service_user | The Linux username for ownership of configuration files | `string` | `kafka` | no |
| lvm_block_definitions | LVM block definitions. Must include an entry for `/dev/xvdb`. | `list(object({ aws_volume_size_gb = string, filesystem_resize_tool = string, lvm_logical_volume_device_node = string, lvm_physical_volume_device_node = string }))` | n/a | yes |
| ns_update_key_content | The content of the key used for nameserver updates | `string` | n/a | yes |
| ns_update_key_path | The path at which to store the key used for nameserver updates | `string` | `/root` | no |
| prometheus_access | An object defining CIDR blocks and prefix list ids controlling access to Prometheus | `object({ cidr_blocks = list(string), list_ids = list(string) })` | `{ cidr_blocks = [], list_ids = [] }` | no |
| root_volume_size_gib | The size of the root volume in GiB; set this value to 0 to preserve AMI size | `number` | n/a | yes |
| route53_available | A flag indicating whether Route53 is available | `bool` | n/a | yes |
| service | The service name to be used when creating AWS resources | `string` | n/a | yes |
| service_sub_type | The service subtype name to be used when creating AWS resources | `string` | n/a | yes |
| ssm_kms_key | Optional KMS key ID or alias to allow SSM session encryption permissions | `string` | `null` | no |
| subnets | A map of subnets keyed by availability zone | `map(any)` | n/a | yes |
| team | The team responsible for administering the instance | `string` | n/a | yes |
| user_data_merge_strategy | Merge strategy to apply to user-data sections for cloud-init | `string` | `list(append)+dict(recurse_array)+str()` | no |
| vpc_id | The VPC ID in which to create resources | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| brokers | A list of the Kafka broker connection strings for convenience |
| instance_ips | The IPs of the provisioned hosts |
| instance_profile | The IAM instance profile used by Kafka brokers |
| debug | Additional output for debugging |
| manual_steps | A map of any manual steps that need to be carried out |
