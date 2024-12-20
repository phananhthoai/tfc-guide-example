# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}
#provider "google" {
#  project = "automatic-tract-403610"
#  region  = "us-central1"
#  zone    = "us-central1-a"
#}

provider "cloudflare" {

}


# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

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

resource "aws_vpc_peering_connection" "source_to_target" {
  vpc_id        = var.source_vpc_id
  peer_vpc_id   = var.target_vpc_id
  peer_owner_id = var.target_account_id
  auto_accept   = false

  tags = {
    Name = "Source-to-Target-Peering"
  }
}

data "aws_vpc" "source_vpc" {
  id = var.source_vpc_id  # ID của VPC hiện có
}

# resource "aws_instance" "ubuntu" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = var.instance_type
#   subnet_id = data.aws_subnets.vpc_subnets.id'  

#   tags = {
#     Name = var.instance_name
#   }
# }


# resource "aws_eip" "lb" {
#  instance = aws_instance.ubuntu.id
#  domain   = "vpc"
# }

# data "cloudflare_zone" "main" {
#   name = var.zone_name
# }

# resource "cloudflare_record" "aws" {
#   zone_id = data.cloudflare_zone.main.id
#   name    = "k8s"
#   value   = aws_eip.lb.public_ip
#   type    = "A"
#   proxied = false
# }

#resource "cloudflare_record" "google" {
#  zone_id = data.cloudflare_zone.main.id
#  name    = "k8s"
#  value   = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
#  type    = "A"
#  proxied = false
#}
