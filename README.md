# kafka-stack-configuration

## Introduction

These scripts are used to configure the kafka stack

## Roles

- Grafana - Configure Grafana using the API

### Grafana Role

Makes requests against the Grafana API to manage an environments space and its index patterns.
If an environment has not been defined within this role it will be removed from the kafka-stack.

## Running

The playbooks are invoked through the `ansible-runner`.
