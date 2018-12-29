########################################################################################################
#Security Variables for AWS
########################################################################################################
variable "name" {default = "Factorsense"}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "cidr_block" {}
variable "region" {}
variable "subnet_bits" {}
variable "availability_zones" {}

########################################################################################################
# Provider
########################################################################################################

provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.region}"
}

########################################################################################################
# Create a VPC
########################################################################################################

resource "aws_vpc" "vpc_factorsense" {
    cidr_block           = "${var.cidr_block}"
    enable_dns_support   = true
    enable_dns_hostnames = true 
    instance_tenancy = "default"
    tags {
        Name        = "VPC-${var.name}"
        Environment = "${lower(var.name)}"
    }
}

########################################################################################################
# Create an Subnets and attach to VPC and Internet Gateway
########################################################################################################

resource "aws_subnet" "subnet_public" {
  count             = "${length(split(",", var.availability_zones))}"
  vpc_id            = "${aws_vpc.vpc_factorsense.id}"
  availability_zone = "${element(split(",",var.availability_zones), count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+1)}"

 tags {
    Name = "subnet_public-${count.index}"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = "${length(split(",", var.availability_zones))}"
  vpc_id            = "${aws_vpc.vpc_factorsense.id}"
  availability_zone = "${element(split(",",var.availability_zones), count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+3)}"

 tags {
    Name = "subnet_private-${count.index}"
  }
}
