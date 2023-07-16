# Azure Provider Configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Create QA Resource Group
resource "azurerm_resource_group" "qa_resource_group" {
  name     = var.qa_resource_group_name
  location = var.qa_location
}

# Create QA Virtual Network
resource "azurerm_virtual_network" "qa_vnet" {
  name                = "qa-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.qa_location
  resource_group_name = azurerm_resource_group.qa_resource_group.name
}

# Create QA Subnet
resource "azurerm_subnet" "qa_subnet" {
  name                 = "qa-subnet"
  resource_group_name  = azurerm_resource_group.qa_resource_group.name
  virtual_network_name = azurerm_virtual_network.qa_vnet.name
  address_prefixes      = ["10.1.0.0/24"]
}

# Create QA VMs
resource "azurerm_virtual_machine" "qa_vm" {
  count               = 4
  name                = "qa-vm-${count.index + 1}"
  location            = var.qa_location
  resource_group_name = azurerm_resource_group.qa_resource_group.name

  vm_size = "Standard_DS1_v2"  # Update with your desired VM size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "qa-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 128  # Update with your desired disk size
  }

  os_profile {
    computer_name  = "qa-vm-${count.index + 1}"
    admin_username = "adminuser"  # Update with your desired admin username
    admin_password = "ChangeMe007!"  # Update with your desired admin password
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Update based on your authentication preference
  }

  network_interface_ids = [azurerm_network_interface.qa_nic[count.index].id]
}

resource "azurerm_network_interface" "qa_nic" {
  count               = 4
  name                = "qa-nic-${count.index + 1}"
  location            = var.qa_location
  resource_group_name = azurerm_resource_group.qa_resource_group.name

  ip_configuration {
    name                          = "qa-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.qa_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

