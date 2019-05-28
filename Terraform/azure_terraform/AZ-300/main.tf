########################################################################################################
# Variables
########################################################################################################
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

########################################################################################################
# Create resource Group
########################################################################################################

resource "azurerm_resource_group" "az300" {
    name = "factorsense-westeu-dev-az300-internal-RG"
    location = "west europe"

    tags = {
        environment = "development"
        purpose = "az300"
    }
}

########################################################################################################
# Create Virtual Network 
########################################################################################################

resource "azurerm_network_security_group" "az300_nsg" {
    name = "factorsense-westeu-dev-az300-nsg"
    location = "${azurerm_resource_group.az300.location}"
    resource_group_name = "${azurerm_resource_group.az300.name}"


    security_rule {
        name = "AllowRDP"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "development"
        purpose = "az300"
    }
}

resource "azurerm_virtual_network" "az300_vnet" {
  name                = "factorsense-westeu-dev-az300-Vnet"
  location            = "${azurerm_resource_group.az300.location}"
  resource_group_name = "${azurerm_resource_group.az300.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
      environment = "development"
      purpose = "az300"

  }
}

resource "azurerm_public_ip" "azure_300_public_ip" {
    name = "factorsense-westeu-dev-az300-PublicIP"
    resource_group_name = "${azurerm_resource_group.az300.name}"
    location            = "${azurerm_resource_group.az300.location}"
    idle_timeout_in_minutes = 30
    allocation_method = "Static"
    sku = "Standard"

      tags = {
      environment = "development"
      purpose = "az300"

  }
}


resource "azurerm_subnet" "az300_private" {
        name           = "az300_private"
        resource_group_name = "${azurerm_resource_group.az300.name}"
        virtual_network_name = "${azurerm_virtual_network.az300_vnet.name}"
        address_prefix = "10.0.1.0/24"

}

resource "azurerm_subnet" "az300_public" {
        name           = "az300_public"
        resource_group_name = "${azurerm_resource_group.az300.name}"
        virtual_network_name = "${azurerm_virtual_network.az300_vnet.name}"
        address_prefix = "10.0.2.0/24"
        network_security_group_id = "${azurerm_network_security_group.az300_nsg.id}"

}



resource "azurerm_network_interface" "az300_nic" {
    name = "az300_nic_01"
    resource_group_name = "${azurerm_resource_group.az300.name}"
    location = "${azurerm_resource_group.az300.location}"

    ip_configuration{
        name = "az300_nic_01_ip"
        subnet_id = "${azurerm_subnet.az300_private.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = "${azurerm_public_ip.azure_300_public_ip.id}"
    }
        tags = {
            environment = "development"
            purpose = "az300"
            public = "False"
    }
}


resource "azurerm_network_interface" "az300_nic_02" {
    name = "az300_nic_02"
    resource_group_name = "${azurerm_resource_group.az300.name}"
    location = "${azurerm_resource_group.az300.location}"

    ip_configuration{
        name = "az300_nic_02_ip"
        subnet_id = "${azurerm_subnet.az300_public.id}"
        private_ip_address_allocation = "Dynamic"
    }
        tags = {
            environment = "development"
            purpose = "az300"
            public = "true"
    }
}