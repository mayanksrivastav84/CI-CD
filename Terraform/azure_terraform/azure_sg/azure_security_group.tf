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

resource "azurerm_network_security_group" "fs_nw_security_grp" {
  name                = "fs_nw_security_grp"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"

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