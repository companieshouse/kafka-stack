# shared

Provisions resources shared across the stack

## Terraform variables

| Name            | Description                                                            | Default       | Example          | Notes        |
| --------------- | ---------------------------------------------------------------------- | ------------- | ---------------- | ------------ |
| account_name    | The name of the AWS account we're using                                | `-`           | `development`    | -            |
| debug           | A flag indicating whether to output additional debug level information | `false`       | `true`           | -            |
| environment     | The environment name to be used when creating AWS resources            | `-`           | `my_environment` | -            |
| region          | The AWS region in which resources will be administered                 | `-`           | `eu-west-2`      | -            |
| repository_name | The name of the repository in which we're operating                    | `kafka-stack` | `-`              | `deprecated` |
| service         | The service name to be used when creating AWS resources                | `kafka3`      | `-`              | -            |
| team            | The team responsible for administering the instance                    | `platform`    | `my-team`        | -            |
