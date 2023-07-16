# Azure Provider Configuration
provider "azurerm" {
  features {
     resource_group {
       prevent_deletion_if_contains_resources = false
}
}
}

# Create Dev Resource Group
resource "azurerm_resource_group" "dev_resource_group" {
  name     = var.dev_resource_group_name
  location = var.dev_location
}

# Create Dev Virtual Network
resource "azurerm_virtual_network" "dev_vnet" {
  name                = "dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.dev_location
  resource_group_name = azurerm_resource_group.dev_resource_group.name
}

# Create Dev Subnet
resource "azurerm_subnet" "dev_subnet" {
  name                 = "dev-subnet"
  resource_group_name  = azurerm_resource_group.dev_resource_group.name
  virtual_network_name = azurerm_virtual_network.dev_vnet.name
  address_prefixes      = ["10.0.0.0/24"]
}

# Create Dev VMs
resource "azurerm_virtual_machine" "dev_vm" {
  count               = 3
  name                = "dev-vm-${count.index + 1}"
  location            = var.dev_location
  resource_group_name = azurerm_resource_group.dev_resource_group.name

  vm_size = "Standard_DS1_v2"  # Update with your desired VM size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "dev-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 128  # Update with your desired disk size
  }

  os_profile {
    computer_name  = "dev-vm-${count.index + 1}"
    admin_username = "adminuser"  # Update with your desired admin username
    admin_password = "ChangeMe007!"  # Update with your desired admin password
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Update based on your authentication preference
  }

  network_interface_ids = [azurerm_network_interface.dev_nic[count.index].id]
}

resource "azurerm_network_interface" "dev_nic" {
  count               = 3
  name                = "dev-nic-${count.index + 1}"
  location            = var.dev_location
  resource_group_name = azurerm_resource_group.dev_resource_group.name

  ip_configuration {
    name                          = "dev-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.dev_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

