# kafka

Provisions a Kafka cluster

## Terraform variables

| Name                        | Description                                                                                                                                                                                                                                                                                                                                                   | Default            | Example                           | Notes        |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ | --------------------------------- | ------------ |
| account_name                | The name of the AWS account we're using                                                                                                                                                                                                                                                                                                                       | `-`                | `development`                     | -            |
| debug                       | A flag indicating whether to output additional debug level information                                                                                                                                                                                                                                                                                        | `false`            | `true`                            | -            |
| environment                 | The environment name to be used when creating AWS resources                                                                                                                                                                                                                                                                                                   | `-`                | `my_environment`                  | -            |
| default_ami_version_pattern | The default AMI version pattern to use when matching AMIs for instances                                                                                                                                                                                                                                                                                       | `\\d.\\d.\\d-\\d+` | `1.2.3`                           | -            |
| default_instance_type       | The default instance type to use for instances                                                                                                                                                                                                                                                                                                                | `t3.medium`        | `-`                               | -            |
| instance_specifications     | A map of specifications for the instances                                                                                                                                                                                                                                                                                                                     | `-`                | `{ "eu-west-2a" = { "1" = {} } }` | -            |
| lvm_block_definitions       | Kafka LVM block definitions                                                                                                                                                                                                                                                                                                                                   | `...`              | `-`                               | -            |
| root_volume_size_gib        | The size of the kafka root volume in GiB; set this value to 0 to preserve the size specified in the AMI metadata. This value should not be smaller than the size specified in the AMI metadata and used by the root volume snapshot. The filesystem will be expanded automatically to use all available space for the volume and an XFS filesystem is assumed | `50`               | `-`                               | -            |
| region                      | The AWS region in which resources will be administered                                                                                                                                                                                                                                                                                                        | `-`                | `eu-west-2`                       | -            |
| repository_name             | The name of the repository in which we're operating                                                                                                                                                                                                                                                                                                           | `kafka-stack`      | `-`                               | `deprecated` |
| route53_available           | A flag indicating whether Route53 is available                                                                                                                                                                                                                                                                                                                | `-`                | `true`                            | -            |
| service                     | The service name to be used when creating AWS resources                                                                                                                                                                                                                                                                                                       | `kafka3`           | `-`                               | -            |
| team                        | The team responsible for administering the instance                                                                                                                                                                                                                                                                                                           | `platform`         | `my-team`                         | -            |