variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "datacenter" {}
variable "datastore" {}
variable "network" {}
variable "template_name" {}
variable "vsphere_host" {}

variable "vm_name" {}
variable "vm_cpu" { type = number }
variable "vm_memory" { type = number }
variable "vm_disk" { type = number }
variable "vm_ip" {}
variable "vm_gateway" {}
variable "admin_password" {}
