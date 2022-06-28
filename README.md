# kafka-stack

Terraform scripts for provisioning a Kafka cluster

## Applying infrastructure changes

These scripts should be run using Companies House Terraform-runner

View usage instructions for the terraform-runner [here](https://companieshouse.atlassian.net/wiki/spaces/DEVOPS/pages/1694236886/Terraform-runner)

## Groups

This repository comprises the following groups

| Name                                      | Description                                          | Dependencies          |
| ----------------------------------------- | ---------------------------------------------------- | --------------------- |
| [grafana](groups/grafana/README.md)       | Provisions Grafana                                   | `shared`              |
| [kafka](groups/kafka/README.md)           | Provisions a Kafka cluster                           | `shared`, `zookeeper` |
| [prometheus](groups/prometheus/README.md) | Provisions Prometheus                                | `shared`              |
| [shared](groups/shared/README.md)         | Provisions infrastructure shared by the other groups | -                     |
| [zookeeper](groups/zookeeper/README.md)   | Provisions a Zookeeper cluster                       | `shared`              |

**Note:** In the table above `Dependencies` indicates that the group will fail to provision if the required group hasn’t been provisioned in advance. It should be noted that while the grafana group makes use of infrastructure provisioned in the prometheus group, it does not need it to be provisioned successfully
