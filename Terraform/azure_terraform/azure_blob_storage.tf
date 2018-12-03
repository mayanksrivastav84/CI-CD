########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}
#variable "description" {}
#variable "account_type" {}
variable "resource_group_name" {}
variable "account_tier" {}
variable "account_replication_type" {}
variable "storage_account_name" {}
variable "storage_account_type" {}


########################################################################################################
# Resource provider
########################################################################################################
provider "azurerm"{
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
    alias = "arm-1"
}

########################################################################################################
# Create azure storage service
########################################################################################################
resource "azurerm_managed_disk" "factorsense" {
  name                 = "managed_disk_name"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "${var.storage_account_type}"
  create_option        = "Empty"
  disk_size_gb         = "1"
}



resource "azurerm_storage_account" "fstorage" {
  name         = "${var.storage_account_name}"
  location     = "${var.location}"
  #description  = "${var.description}"
  #account_type = "${var.account_type}"
  resource_group_name= ""
  account_tier ="${var.account_tier}"
  account_replication_type ="${var.account_replication_type}"
}