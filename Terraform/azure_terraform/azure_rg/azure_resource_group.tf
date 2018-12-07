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

resource "azurerm_resource_group" "webapp_factorsense" {

    name = "webapp_factorsense"
    location = "West Europe"

    tags {
        environment = "Production"
    }

}

########################################################################################################
# Create a Azure Recovery service vault 
########################################################################################################
resource "azurerm_recovery_services_vault" "fsvault" {
  name                = "fsvault"
  location            = "${azurerm_resource_group.factorsense.location}"
  resource_group_name = "${azurerm_resource_group.factorsense.name}"
  sku                 = "standard"
}
