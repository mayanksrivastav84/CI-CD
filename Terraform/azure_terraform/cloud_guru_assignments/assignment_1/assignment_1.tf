########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "prefix" {
  default = "cloudguru"
}


########################################################################################################
# Create resource Group
########################################################################################################
resource "azurerm_resource_group" "cloud_guru" {

    name = "${var.prefix}-resourcegroup"
    location = "West Europe"

    tags {
        environment = "Production"
    }

}

########################################################################################################
# Create a Azure virtual Network
########################################################################################################
resource "azurerm_virtual_network" "cloudguru_main" {
  name                = "${var.prefix}-vnet"
  location            = "${azurerm_resource_group.cloud_guru.location}"
  resource_group_name = "${azurerm_resource_group.cloud_guru.name}"
  address_space       = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "cloud_guru_subnet" {
  name                 = "cloudguru_subnet"
  resource_group_name  = "${azurerm_resource_group.cloud_guru.name}"
  virtual_network_name = "${azurerm_virtual_network.cloudguru_main.name}"
  address_prefix       = "10.1.0.0/26"
}
