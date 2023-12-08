# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

provider "google" {
  project = "automatic-tract-403610"
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "cloudflare" {
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "google_compute_image" "my_image" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}


data "cloudflare_zone" "main" {
  name = var.zone_name
}

resource "cloudflare_record" "aws" {
  zone_id = data.cloudflare_zone.main.id
  name    = "aws"
  value   = aws_instance.ubuntu.public_ip
  type    = "A"
  proxied = false
}
