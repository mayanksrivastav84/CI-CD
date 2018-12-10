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
# Create Storage Account, Storage Container and Storage Blob
########################################################################################################

resource "azurerm_storage_account" "fs_storage_account" {
  name                     = "factorsense"
  resource_group_name      = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "fs_storage_container" {
  name                  = "fsstor"
  resource_group_name   = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  storage_account_name  = "${azurerm_storage_account.fs_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "fssb" {
  name = "fs.vhd"

  resource_group_name    = "${data.azurerm_resource_group.fs-resourcegroup.name}"
  storage_account_name   = "${azurerm_storage_account.fs_storage_account.name}"
  storage_container_name = "${azurerm_storage_container.fs_storage_container.name}"

  type = "page"
  size = 5120
}

