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
# Create a Azure Resource Group on Azure
########################################################################################################

resource "azurerm_resource_group" "rg_main" {

    name = "${var.prefix}-resourcegroup"
    location = "West Europe"

    tags {
        environment = "Production"
    }

}

########################################################################################################
# Create a Azure virtual Network
########################################################################################################
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

resource "azurerm_virtual_network" "vn_main" {
  name                = "${var.prefix}-network"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet_main" {
  name                 = "main_subnet"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  virtual_network_name = "${azurerm_virtual_network.vn_main.id}"
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_subnet" "subnet_secondary" {
  name                 = "main_subnet"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  virtual_network_name = "${azurerm_virtual_network.vn_main.id}"
  address_prefix       = "10.0.3.0/24"
}


resource "azurerm_network_interface" "nw_interface_main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${azurerm_subnet.subnet_main.id}"
    private_ip_address_allocation = "dynamic"
  }
}


########################################################################################################
# Create a Azure virtual machines
########################################################################################################

resource "azurerm_virtual_machine" "main_vm" {
  name                  =   "${var.prefix}-vm"
  location              =   "${azurerm_resource_group.rg_main.location}"
  resource_group_name   =   "${azurerm_resource_group.rg_main.name}"
  network_interface_ids  =   ["${azurerm_network_interface.nw_interface_main.id}"]
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
    admin_username = "admin"
    admin_password = "Residency18"
  }

   os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "staging"
  }
}