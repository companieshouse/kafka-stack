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
  description = "The AWS region in which resources will be administered"
  type        = string
}

variable "repository_name" {
  default     = "kafka-stack"
  description = "The name of the repository in which we're operating"
  type        = string
}

variable "service" {
  default     = "kafka3"
  description = "The service name to be used when creating AWS resources"
  type        = string
}

variable "team" {
  default     = "platform"
  description = "The team responsible for administering the instance"
  type        = string
}
