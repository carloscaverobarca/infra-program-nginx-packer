locals {
  ingress = [
    { from_port = 22, protocol = "tcp", to_port = 22, cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 80, protocol = "tcp", to_port = 80, cidr_blocks = ["0.0.0.0/0"] }
  ]

  egress = [
    { from_port = 0, protocol = "-1", to_port = 0, cidr_blocks = ["0.0.0.0/0"] }
  ]

  subnets = {
    "web" = {  cidr_block = "172.16.10.0/24", availability_zone = "eu-central-1a", name = "web", map_public_ip = true }
  }
}