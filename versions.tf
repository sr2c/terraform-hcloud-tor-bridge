terraform {
  required_version = ">= 0.15.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.31.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}