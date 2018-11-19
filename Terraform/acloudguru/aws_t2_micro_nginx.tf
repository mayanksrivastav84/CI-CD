########################################################################################################
#Security Variables for AWS
########################################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
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
resource "aws_instance" "nginx" {
  ami           = "ami-6871a115"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum install nginx -y",
      "sudo service nginx start"
      ]
    }
 }

########################################################################################################
# Output from Deployment
########################################################################################################
output "aws_instance_public_dns" {
  value = "${aws_instance.nginx.public_dns}"
}