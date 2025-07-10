terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.5.0" # Important pour activer la personnalisation
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# 📍 Récupère le datacenter "AUTO-INFRA"
data "vsphere_datacenter" "datacenter" {
  name = "AUTO-INFRA"
}

# 📦 Récupère le datastore "datastore1"
data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# 🧠 Récupère le cluster de calcul "automation-Infra"
data "vsphere_compute_cluster" "cluster" {
  name          = "Automation-Infra"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# 🌐 Récupère le réseau virtuel "VM Network"
data "vsphere_network" "network" {
  name          = "ESXi-VM-Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# 📄 Récupère le template Windows existant "template-windows-server"
data "vsphere_virtual_machine" "template" {
  name          = "template-windows-server"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# 🚀 Création de la VM à partir du template
resource "vsphere_virtual_machine" "vm" {
  name             = "win-vm-001"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "Hard Disk 1"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name  = "win-vm-001"
        admin_password = var.admin_password
        time_zone      = 004  # Tunis/Paris (GMT+1)
      }

      network_interface {
        ipv4_address = var.vm_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.vm_gateway
    }
  }
}
