variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "my-resource-group"
}

variable "location" {
  description = "Azure region"
  default     = "westus2"
}

variable "vm_count" {
  description = "Number of VM instances to create"
  default     = 1
}

variable "vm_size" {
  description = "VM size"
  default     = "Standard_DS2_v2"
}

variable "admin_username" {
  description = "Admin username for VMs"
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  default     = "P@ssw0rd123"
}

