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
# Create Security Group
########################################################################################################
resource "azurerm_resource_group" "rg_main" {

    name = "${var.prefix}-resourcegroup"
    location = "West Europe"

    tags {
        environment = "Production"
    }

}