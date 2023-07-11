resource "azurerm_resource_group" "nic_example" {
  name     = "nic_example-resource-group"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "nicexample-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.nic_example.location
  resource_group_name = azurerm_resource_group.nic_example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.nic_example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "nic-example-nsg"
  location            = azurerm_resource_group.nic_example.location
  resource_group_name = azurerm_resource_group.nic_example.name
}

resource "azurerm_network_interface" "example" {
  count               = 2
  name                = "example-nic-${count.index}"
  location            = azurerm_resource_group.nic_example.location
  resource_group_name = azurerm_resource_group.nic_example.name

  ip_configuration {
    name                          = "example-ip-config-${count.index}"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  count                 = 2
  name                  = "example-vm-${count.index}"
  location              = azurerm_resource_group.nic_example.location
  resource_group_name   = azurerm_resource_group.nic_example.name
  network_interface_ids = [azurerm_network_interface.example[count.index].id]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "example-vm-${count.index}"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_mssql_server" "nicexample" {
  name                         = "nictrserver"
  resource_group_name          = azurerm_resource_group.nic_example.name
  location                     = azurerm_resource_group.nic_example.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "P@ssw0rd123!"
}

resource "azurerm_mssql_database" "nicexample" {
  name                  = "nicexample-database"
  server_id             = azurerm_mssql_server.nicexample.id
  sku_name              = "Basic"
  read_scale            = false
  depends_on = [azurerm_mssql_server.nicexample]
}
# Add this to your existing configuration

# Create an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = "example-asp"
  location            = azurerm_resource_group.nic_example.location
  resource_group_name = azurerm_resource_group.nic_example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create an App Service
resource "azurerm_app_service" "example" {
  name                = "foltrexample-appservice"
  location            = azurerm_resource_group.nic_example.location
  resource_group_name = azurerm_resource_group.nic_example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_mssql_server.nicexample.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.nicexample.name};Persist Security Info=False;User ID=${azurerm_mssql_server.nicexample.administrator_login};Password=${azurerm_mssql_server.nicexample.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

