# Proxmox

variable "api_proxmox" {
    type       = string
}

variable "prox_user" {
    type       = string
}

variable "prox_pass" {
  type         = string
  sensitive    = true
}

variable "ubuntu_user" {
    type       = string
}

variable "ubuntu_pass" {
    type       = string
    sensitive  = true
}

variable "ssh" {
    type      = string 
} 

variable "vlan" {
    type      = number
}




