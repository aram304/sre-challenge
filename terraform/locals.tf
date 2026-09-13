locals {

  traditional_ip  = one([
    for ip in flatten(proxmox_virtual_environment_vm.traditional.ipv4_addresses) :
      ip if startswith(ip, "${var.prefix}")
    ]) 

  traditional_vmid = proxmox_virtual_environment_vm.traditional.vm_id

  minikube_ip  = one([
      for ip in flatten(proxmox_virtual_environment_vm.minikube.ipv4_addresses) :
      ip if startswith(ip,"${var.prefix}")
    ]) 

  minikube_vmid = proxmox_virtual_environment_vm.minikube.vm_id
}