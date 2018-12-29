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
# Provider
########################################################################################################

provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.region}"
}


########################################################################################################
# List all the availability zones in the region 
########################################################################################################

data "aws_availability_zones" "availability_zones" {}



########################################################################################################
# Create Elastic IP Address
########################################################################################################
resource "aws_eip" "NAT_Elastic_IP" {
  count             = "${length(data.aws_availability_zones.availability_zones.names)}"
  vpc = true

  tags = {
    Name = "NAT_Elastic_IP-${count.index}"
  }

}
