terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }

  cloud {
    organization = "sre-challenge"

    workspaces {
      name = "sre-challenge"
    }
  }
}