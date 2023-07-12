#Author: Nicholas Gulrajani
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {
  resource_group {
  prevent_deletion_if_contains_resources = false
}
}
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
  default     = "niclookup-resource-group"
}

variable "location" {
  type        = string
  description = "Location for the resources."
  default     = "West US"
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine."
  default     = "my-vm"
}

variable "vm_size" {
  type        = string
  description = "Size of the virtual machine."
  default     = "Standard_DS2_v2"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machine."
  default     = "adminuser"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the virtual machine."
  default     = "AdminPassword123!"
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "nicho-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  dns_servers         = [var.dns_servers[var.environment]]
}


resource "azurerm_subnet" "example" {
  name                 = "nicho-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "my-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = "my-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "my-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}

