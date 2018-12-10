########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "prefix" {
  default = "fs"
}

########################################################################################################
# Access Details of the Azure Resource Group
########################################################################################################

data "azurerm_resource_group" "fs-resourcegroup" {
  name = "fs-resourcegroup"
}

output "resource_group_name" {
  value = "${data.azurerm_resource_group.fs-resourcegroup.name}"
}

output "resource_group_location" {
  value = "${data.azurerm_resource_group.fs-resourcegroup.location}"
}


########################################################################################################
# Create a Azure virtual Network
########################################################################################################
resource "azurerm_virtual_network" "vnet-main" {
  name                = "${var.prefix}-network"
  location            = "${data.azurerm_resource_group.fs-resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet_main" {
  name                 = "subnet_main"
  resource_group_name  = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet-main.name}"
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_subnet" "subnet_secondary" {
  name                 = "subnet_secondary"
  resource_group_name  = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet-main.name}"
  address_prefix       = "10.0.3.0/24"
}


resource "azurerm_network_interface" "nw_interface_main" {
  name                = "${var.prefix}-nic_main"
  location            = "${data.azurerm_resource_group.fs-resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.fs-resourcegroup.name}"

  ip_configuration {
    name                          = "IPConfiguration_main"
    subnet_id                     = "${azurerm_subnet.subnet_main.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "nw_interface_secondary" {
  name                = "${var.prefix}-nic_sec"
  location            = "${data.azurerm_resource_group.fs-resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.fs-resourcegroup.name}"

  ip_configuration {
    name                          = "IPConfiguration_sec"
    subnet_id                     = "${azurerm_subnet.subnet_secondary.id}"
    private_ip_address_allocation = "dynamic"
  }
}

