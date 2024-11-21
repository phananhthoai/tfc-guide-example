# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# output "instance_ami" {
#   value = aws_instance.ubuntu.ami
# }

# output "instance_arn" {
#   value = aws_instance.ubuntu.arn
# }

output "peering_connection_id" {
  value = aws_vpc_peering_connection.source_to_target.id
}

output "source_vpc_cidr" {
  value = data.aws_vpc.source_vpc.cidr_block
}