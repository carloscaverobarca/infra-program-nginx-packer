## Use your AWS account profile
variable "profile" {
  default = ""
}

## Please use your region
variable "region" {
  default = ""
}

## Copy the result of packer execution here
variable "ami" {
  default = ""
}

variable "instance" {
  default = "t2.micro"
}

variable "private_key_aws_path" {
  type = string
  default = "~/.ssh/mykeytest.pem"
}

variable "aws_sg_name" {
  type = string
  default = "web_ccb_sg"
}