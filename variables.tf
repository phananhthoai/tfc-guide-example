# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "source_vpc_id" {
  description = "VPC_SOURCE"
  default = "vpc-091932e7ff87b028d"
}

variable "target_vpc_id" {
  description = "VPC_TARGET"
  default = "vpc-0fe88d8a01739b552"
}

variable "target_account_id" {
  description = "TARGET_ACCOUNT_IT"
  default = "774305602364"
}
# variable "instance_type" {
#   description = "Type of EC2 instance to provision"
#   default     = "t2.micro"
# }

# variable "instance_name" {
#   description = "EC2 instance name"
#   default     = "Provisioned by Terraform"
# }

# variable "zone_name" {
#   description = "Zone domain"
#   default     = "hocdevops.me"
# }

# variable "source_vpc_id" {
#   description = "ID of the existing VPC in source account"
#   default = "vpc-091932e7ff87b028d"
# }

# variable "target_vpc_id" {
#   description = "ID of the VPC in target account"
#   default = "vpc-07711d433e633ca39"
# }

# variable "target_account_id" {
#   description = "AWS Account ID of the target account"
#   default = "774305602364"
# }