########################################################################################################
#Security Variables for AWS
########################################################################################################
variable "name" {default = "Factorsense"}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "cidr_block" {}
variable "region" {}
variable "subnet_bits" {}
variable "vpc_name" {}

########################################################################################################
# List all the availability zones in the region 
########################################################################################################

data "aws_availability_zones" "availability_zones" {}

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
# Create Internet Gateway and attach to VPC
########################################################################################################

resource "aws_internet_gateway" "igw" {

  vpc_id  = "${aws_vpc.vpc_factorsense.id}"
  
  tags = {
    Name = "main"
  }
}

########################################################################################################
# Create Public and private subnets in each Availability Zone. 
########################################################################################################

resource "aws_subnet" "subnet_public" {
  count                   = "${length(data.aws_availability_zones.availability_zones.names)}"
  vpc_id                  = "${aws_vpc.vpc_factorsense.id}"
  availability_zone       = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+1)}"
  map_public_ip_on_launch = "True"

 tags {
    Name = "subnet_public-${count.index}"
  }
}


resource "aws_subnet" "subnet_private" {
  count             = "${length(data.aws_availability_zones.availability_zones.names)}"
  vpc_id            = "${aws_vpc.vpc_factorsense.id}"
  availability_zone = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+4)}"

 tags {
    Name = "subnet_private-${count.index}"
  }
}

########################################################################################################
# Create Route Tables
########################################################################################################
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc_factorsense.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "Public Route"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = "${aws_vpc.vpc_factorsense.id}"
  
  tags = {
    Name = "Private Route"
  }
}


########################################################################################################
# Route Tables Association
########################################################################################################

resource "aws_route_table_association" "private_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)}"
    subnet_id         = "${element(aws_subnet.subnet_private.*.id, count.index)}"
    route_table_id    = "${aws_route_table.private_route.id}"

}



resource "aws_route_table_association" "public_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)}"
    subnet_id         = "${element(aws_subnet.subnet_public.*.id, count.index)}"
    route_table_id    = "${aws_route_table.public_route.id}"

}


########################################################################################################
# NACL to allow 
########################################################################################################
