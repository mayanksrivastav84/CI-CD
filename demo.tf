variable "aws_access_key" {}
variale  "aws_secret_key" {}

provider "aws" {
aws_access_key = "access_key"
aws_secret_key = "secret_key"
region = "us-east-1"
}
