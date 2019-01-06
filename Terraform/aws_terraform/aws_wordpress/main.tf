########################################################################################################
#Security Variables for AWS
########################################################################################################
variable "name" {default = "fs-wordpress"}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "cidr_block" {}
variable "region" {}
variable "subnet_bits" {}
variable "Environment" {}

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

resource "aws_vpc" "wordpress-factorsense" {
    cidr_block           = "${var.cidr_block}"
    enable_dns_support   = true
    enable_dns_hostnames = true 
    instance_tenancy = "default"
    tags {
        Name        = "wordpress-${var.name}"
        Environment = "${lower(var.Environment)}"
    }
}

########################################################################################################
# Create Internet Gateway and attach to VPC
########################################################################################################

resource "aws_internet_gateway" "igw" {

  vpc_id  = "${aws_vpc.wordpress-factorsense.id}"
  
  tags = {
    Name = "InternetGateway"
  }
}

########################################################################################################
# Create Public, data and app  subnets in each Availability Zone. 
########################################################################################################

resource "aws_subnet" "public_subnet" {
  count                   = "${length(data.aws_availability_zones.availability_zones.names)-1}"
  vpc_id                  = "${aws_vpc.wordpress-factorsense.id}"
  availability_zone       = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block              = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+1)}"
  map_public_ip_on_launch = "True"

 tags {
    Name = "public_subnet-${count.index}"
  }
}


resource "aws_subnet" "private_app_subnet" {
  count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
  vpc_id            = "${aws_vpc.wordpress-factorsense.id}"
  availability_zone = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+4)}"

 tags {
    Name = "private_app_subnet-${count.index}"
  }
}

resource "aws_subnet" "private_data_subnet" {
  count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
  vpc_id            = "${aws_vpc.wordpress-factorsense.id}"
  availability_zone = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, var.subnet_bits, count.index+8)}"

 tags {
    Name = "private_data_subnet-${count.index}"
  }
}




########################################################################################################
# Create Elastic IP Address
########################################################################################################

resource "aws_eip" "wp_ip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.igw"]
}

########################################################################################################
# Create NAT Gateway
########################################################################################################
resource "aws_nat_gateway" "worpress_nat" {
    allocation_id = "${aws_eip.wp_ip.id}"
    subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    depends_on    = ["aws_internet_gateway.igw"]
}


#######################################################################################################
# Create Route Tables
########################################################################################################
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.wordpress-factorsense.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"

    
  }
    tags = {
    Name = "Public Route"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = "${aws_vpc.wordpress-factorsense.id}"
  
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.worpress_nat.id}"  
}
  
  tags = {
    Name = "Private Route"
  }
}
########################################################################################################
# Route Tables Association
########################################################################################################

resource "aws_route_table_association" "private_data_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
    subnet_id         = "${element(aws_subnet.private_data_subnet.*.id, count.index)}"
    route_table_id    = "${aws_route_table.private_route.id}"

}

resource "aws_route_table_association" "private_app_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
    subnet_id         = "${element(aws_subnet.private_app_subnet.*.id, count.index)}"
    route_table_id    = "${aws_route_table.private_route.id}"

}

resource "aws_route_table_association" "public_subnet" {
    count             = "${length(data.aws_availability_zones.availability_zones.names)-1}"
    subnet_id         = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    route_table_id    = "${aws_route_table.public_route.id}"

}
