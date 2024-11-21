# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Provisioned by Terraform"
}

variable "zone_name" {
  description = "Zone domain"
  default     = "hocdevops.me"
}

variable "target_vpc_id" {
  description = "CIDR block for the target VPC"
  default = "vpc-091932e7ff87b028d"
}

variable "source_vpc_id" {
  description = "CIDR block for the source VPC"
  type        = string
  default     = "10.1.0.0/16"
  
}

variable "target_account_id" {
  description = "AWS Account ID của VPC đích"
  type        = string
  default     = "0487-6664-8159"
}


variable "peer_region" {
  description = "Region của VPC đích"
  type        = string
  default     = "ap-southeast-1"
}