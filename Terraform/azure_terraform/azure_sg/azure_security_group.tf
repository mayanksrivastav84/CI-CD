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
# Access details of the Resource Group
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
# Create Security Group
########################################################################################################
resource "azurerm_network_security_group" "fs_nw_security_grp" {
  name                = "fs_nw_security_grp"
  location            = "${data.azurerm_resource_group.fs-resourcegroup.location}"
  resource_group_name = "${data.azurerm_resource_group.fs-resourcegroup.name}"

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Production"
  }
}