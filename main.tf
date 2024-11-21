# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region  
}

provider "aws" {
  alias  = "target_account"
  region = var.peer_region
}

#provider "google" {
#  project = "automatic-tract-403610"
#  region  = "us-central1"
#  zone    = "us-central1-a"
#}

provider "cloudflare" {
  api_token = "<token>"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#data "google_compute_image" "my_image" {
#  family  = "ubuntu-2004-lts"
#  project = "ubuntu-os-cloud"
#}

#resource "google_compute_instance" "default" {
#  name         = "my-instance"
#  machine_type = "n2-standard-2"
#  zone         = "us-central1-a"

#  boot_disk {
#    initialize_params {
#      image = data.google_compute_image.my_image.self_link
#    }
#  }

#  scratch_disk {
#    interface = "NVME"
#  }

#  network_interface {
#    network = "default"

#    access_config {
#    }
#  }
#}

# data "aws_subnets" "target_subnets" {
# 	filter {
#   	name = "vpc_id"
#   	values = [var.target_vpc_id]
#   }
# }

data "aws_vpc" "target_vpc" {
  provider = aws.target_account
  id       = var.target_vpc_id
}

resource "aws_vpc" "source_vpc" {
  cidr_block           = var.source_vpc_id
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Source Vpc"
  }
}

resource "aws_subnet" "source_subnet" {
  vpc_id            = aws_vpc.source_vpc.id
  cidr_block        = cidrsubnet(var.source_vpc_id, 8, 1)
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "Source VPC Subnet"
  }
}

resource "aws_internet_gateway" "source_igw" {
  vpc_id = aws_vpc.source_vpc.id
  
  tags = {
    Name = "Source VPC Internet Gateway"
  }
}


resource "aws_vpc_peering_connection" "vpc_peering"  {
  vpc_id        = aws_vpc.source_vpc.id          # ID của VPC mới
  peer_vpc_id   = var.target_vpc_id         # ID của VPC đã tồn tại
  peer_owner_id = var.target_account_id
  peer_region = var.peer_region

  tags = {
    Name = "vpc-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.target_account
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
  
  tags = {
    Name = "VPC Peering Accepter"
  }
}

data "aws_route_tables" "source_route_tables" {
  vpc_id = aws_vpc.source_vpc.id
}

data "aws_route_tables" "target_route_tables" {
  provider = aws.target_account
  vpc_id   = var.target_vpc_id
}

resource "aws_route" "source_to_target" {
  count                     = length(data.aws_route_tables.source_route_tables.ids)
  route_table_id            = data.aws_route_tables.source_route_tables.ids[count.index]
  destination_cidr_block    = data.aws_vpc.target_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Route cho VPC đích
resource "aws_route" "target_to_source" {
  provider                  = aws.target_account
  count                     = length(data.aws_route_tables.target_route_tables.ids)
  route_table_id            = data.aws_route_tables.target_route_tables.ids[count.index]
  destination_cidr_block    = var.source_vpc_id
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.source_vpc.id
  
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Allow SSH"
  }
}


resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.source_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = var.instance_name
  }
}


resource "aws_eip" "lb" {
 instance = aws_instance.ubuntu.id
 domain   = "vpc"
}

data "cloudflare_zone" "main" {
  name = var.zone_name
}

resource "cloudflare_record" "aws" {
  zone_id = data.cloudflare_zone.main.id
  name    = "k8s"
  value   = aws_eip.lb.public_ip
  type    = "A"
  proxied = false
}

#resource "cloudflare_record" "google" {
#  zone_id = data.cloudflare_zone.main.id
#  name    = "k8s"
#  value   = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
#  type    = "A"
#  proxied = false
#}
