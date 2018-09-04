#######################################################################################################
#Security Variables
########################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {
  default = "FactorSense"
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
# RESOURCES
########################################################################################################
#Security Groups
resource "aws_security_group" "nginx-sg" {
  name = "nginx-sg"


  #SSH Access from Anywhere

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  #SSH Access from Anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #SSH Access from Anywhere
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



#Instance

resource "aws_instance" "nginx" {
ami           = "${var.ami_id}"
instance_type = "${var.instance_type}"
vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]
key_name      = "${var.key_name}"


connection {
  user        = "ec2-user"
  private_key = "${file(var.private_key_path)}"
}

}
