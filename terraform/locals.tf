locals {

  traditional_ip  = one([
    for ip in flatten(proxmox_virtual_environment_vm.traditional.ipv4_addresses) :
      ip if startswith(ip, "${192.168.20}")
    ]) 

  traditional_vmid = proxmox_virtual_environment_vm.traditional.vm_id

  minikube_ip  = one([
      for ip in flatten(proxmox_virtual_environment_vm.minikube.ipv4_addresses) :
      ip if startswith(ip,"${192.168.20}")
    ]) 

  minikube_vmid = proxmox_virtual_environment_vm.minikube.vm_id
}