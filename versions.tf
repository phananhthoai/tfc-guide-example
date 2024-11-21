# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  cloud {
    organization = "sbu"

    workspaces {
      name = "source"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    #google = {
    #  source = "hashicorp/google"
    #}

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.32.0"
    }
  }

  required_version = ">= 0.14.0"
}
