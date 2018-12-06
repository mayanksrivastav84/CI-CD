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
    location = "West US"

    tags {
        environment = "Production"
    }

}