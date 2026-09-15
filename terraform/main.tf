# Resource block to create a VM in Proxmox
resource "proxmox_virtual_environment_vm" "traditional" {
  name        = "traditional-webserver"
  node_name   = "NLDW4"

  # Clone the VM from a preconfigured Ubuntu cloud-init template
  clone {
    vm_id = 9000
    full  = true  # Full clone — independent copy, not linked
  }

  cpu {
    cores     = 6
    type      = "x86-64-v2-AES"
  }

  memory {
    dedicated  = 12288
    floating   = 12288
  }

  network_device {
    bridge    = "vmbr1"
    model     = "virtio"
    vlan_id   = 20
    firewall  = false
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         =  50
    discard      = "on"
    ssd          = true
  }

  # Use cloud-init for user creation, SSH access and network settings.
  initialization{
  user_account{
    username    = "${var.ubuntu_user}"
    password    = "${var.ubuntu_pass}"
    keys        = [var.ssh]
                  
    
  }

  ip_config {
    ipv4 {
      address   = "dhcp"
    }
  }

}
  # Wait for the guest agent to report an IPv4 address before proceeding.
  agent {
    enabled = true
    wait_for_ip {
      ipv4  = true
    }
  }

}

resource "proxmox_virtual_environment_vm" "minikube" {
  name        = "minikube-webserver"
  node_name   = "NLDW4"

  clone {
    vm_id = 9000
    full  = true  
  }

  cpu {
    cores     = 6
    type      = "x86-64-v2-AES"
  }

  memory {
    dedicated  = 12288
    floating   = 12288
  }

  network_device {
    bridge    = "vmbr1"
    model     = "virtio"
    vlan_id   = 20
    firewall  = false
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         =  75
    discard      = "on"
    ssd          = true
  }

  initialization{
  user_account{
    username    = "${var.ubuntu_user}"
    password    = "${var.ubuntu_pass}"
    keys        = [var.ssh]
  }

  ip_config {
    ipv4 {
      address   = "dhcp"
    }
  }

}
  
  agent {
    enabled = true
    wait_for_ip {
      ipv4  = true
    }
  }

}

# Generate an Ansible inventory file containing the provisioned VM connection details.
resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../ansible/inventories/inventory.ini"

  content =  <<-EOT
    [traditional]
    traditional-webserver-${local.traditional_vmid} ansible_host=${local.traditional_ip}

    [minikube]
    minikube-webserver-${local.minikube_vmid} ansible_host=${local.minikube_ip}

EOT 
}
