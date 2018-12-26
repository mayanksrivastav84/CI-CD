########################################################################################################
#Security Variables for AWS
########################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "network_address_space" {}
variable "aws_default_region" {}

########################################################################################################
# Provider
########################################################################################################

provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.aws_default_region}"
}

########################################################################################################
# Create a VPC
########################################################################################################

resource "aws_vpc" "vpc_factorsense" {
  cidr_block       = "${var.network_address_space}"
  instance_tenancy = "default"

  tags = {
    Name = "FactorSense VPC"
  }
}


########################################################################################################
# Create an internet gateway and attach to VPC
########################################################################################################
resource "aws_internet_gateway" "factorsense_igw" {
  vpc_id = "${aws_vpc.vpc_factorsense.id}"

  tags = {
    Name = "FactorSense_IGW"
  }
}