########################################################################################################
# Variables for AWS and Azure Resource providers
########################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key"{}




########################################################################################################
# Resource provider
########################################################################################################
provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "us-east-1"
}

provider "azurerm"{
    subscription_id = ""
    client_id = ""
    client_secret = ""
    tenant_id = ""
    alias = "arm-1"
}

resource "azurerm"{
    name = ""
    location = ""
    provider = ""
}

