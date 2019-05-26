########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

########################################################################################################
# Create resource Group
########################################################################################################

resource "azurerm_resource_group" "az300" {
    name = "factorsense-westeu-dev-az300-internal-RG"
    location = "west europe"

    tags = {
        environment = "development"
        purpose = "az300"
    }
}

########################################################################################################
# Create Virtual Network 
########################################################################################################

resource "azurerm_virtual_network" "az300_vnet" {
  name                = "factorsense-westeu-dev-az300-Vnet"
  location            = "${azurerm_resource_group.az300.location}"
  resource_group_name = "${azurerm_resource_group.az300.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "az300_private"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "az300_public"
    address_prefix = "10.0.2.0/24"
  }

  tags = {
      environment = "development"
      purpose = "az300"

  }
}