########################################################################################################
#Security Variables for AWS
########################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "FactorSense"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}

variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}

########################################################################################################
# Provider
########################################################################################################

provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "us-east-1"
}


########################################################################################################
# DATA
########################################################################################################

data "aws_availability_zones" "available" {}

