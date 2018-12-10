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
# Access details of the Network Interface ID 
########################################################################################################

data "azurerm_network_interface" "nw_interface_main" {
  name                = "fs-nic_main"
  resource_group_name = "fs-resourcegroup"
}

output "network_interface_id" {
  value = "${data.azurerm_network_interface.nw_interface_main.id}"
}

########################################################################################################
# Create a Azure virtual machines
########################################################################################################

resource "azurerm_virtual_machine" "main_vm" {
  name                  =   "${var.prefix}-vm"
  location              =   "${data.azurerm_resource_group.fs-resourcegroup.location}"
  resource_group_name   =   "${data.azurerm_resource_group.fs-resourcegroup.name}"
  network_interface_ids  =   ["${data.azurerm_network_interface.nw_interface_main.id}"]
  vm_size               =    "Standard_B1s"

  delete_os_disk_on_termination    =  true

  delete_data_disks_on_termination =  true
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = "$"
    admin_password = ""
  }

   os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "staging"
  }
}