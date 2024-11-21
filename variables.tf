# # Copyright (c) HashiCorp, Inc.
# # SPDX-License-Identifier: MPL-2.0

# variable "region" {
#   description = "AWS region"
#   default     = "ap-southeast-1"
# }

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
variable "target_region" {
  description = "AWS region for target account"
  default     = "ap-southeast-1"
}

variable "target_route_table_id" {
  description = "Route table ID of the target VPC"
}

variable "source_vpc_cidr" {
  description = "CIDR block of the source VPC"
}