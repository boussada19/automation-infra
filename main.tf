provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "y#1>hwAsr%r,sx1"
  vsphere_server       = "10.0.1.50"
  allow_unverified_ssl = true
}

# 1. Datacenter AUTO-INFRA
data "vsphere_datacenter" "dc" {
  name = "AUTO-INFRA"
}

# 2. Datastore1
data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 3. Hôte ESXi (10.1.1.10)
data "vsphere_host" "esxi_host" {
  name          = "10.1.1.10"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 4. Réseau virtuel
data "vsphere_network" "network" {
  name          = "ESXi-VM-Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 5. Template Windows Server
data "vsphere_virtual_machine" "template" {
  name          = "template-windows-server"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# 6. Création de la VM clonée
resource "vsphere_virtual_machine" "vm" {
  name             = "vm-from-template"
  resource_pool_id = data.vsphere_host.esxi_host.resource_pool_id
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
    label            = "Disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
