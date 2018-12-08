########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}


########################################################################################################
# Create a Azure Resource Group on Azure
########################################################################################################

resource "azurerm_resource_group" "factorsense" {

    name = "rg_factorsense"
    location = "West Europe"

    tags {
        environment = "Production"
    }

}

########################################################################################################
# Create a Azure virtual Network
########################################################################################################
resource "azurerm_network_security_group" "fs_securityGroup" {
  name                = "fs_securityGroup"
  location            = "${azurerm_resource_group.factorsense.location}"
  resource_group_name = "${azurerm_resource_group.factorsense.name}"
}

resource "azurerm_virtual_network" "fs_virtualnetwork" {
  name                = "fs_virtualnetwork"
  location            = "${azurerm_resource_group.factorsense.location}"
  resource_group_name = "${azurerm_resource_group.factorsense.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet_finance"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet_risk"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet_treasury"
    address_prefix = "10.0.3.0/24"
    security_group = "${azurerm_network_security_group.fs_securityGroup.id}"
  }

  tags {
    environment = "Production"
  }
}