variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "datacenter" {}
variable "datastore" {}
variable "network" {}
variable "template_name" {}
variable "esxi_host" {}

variable "vm_name" {}
variable "vm_cpu" { type = number }
variable "vm_memory" { type = number }
