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
# Access information about an existing Resource Group.
########################################################################################################

data "azurerm_resource_group" "fs-resourcegroup" {
  name = "fs-resourcegroup"
}

########################################################################################################
# Create CDN Profile
########################################################################################################

resource "azurerm_cdn_profile" "fs_cdn" {
  name                = "fs_cdn"
  location            = "West US"
  resource_group_name = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  sku                 = "Standard_Microsoft"

  tags {
    environment = "Production"
    }
}