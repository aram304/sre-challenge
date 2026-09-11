provider "proxmox" {
  endpoint     = var.api_proxmox
  username     = var.prox_user
  password     = var.prox_pass
  insecure     = true
}