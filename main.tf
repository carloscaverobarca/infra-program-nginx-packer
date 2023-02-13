// Custom network config
module "network" {
  source = "git::git@github.com:carloscaverobarca/infra-program-modules.git//network?ref=1.1"

  vpc_ccb = { name = "tf-example", cidr_block = "172.16.0.0/16"}
  config_subnets = local.subnets
}

resource "aws_instance" "web_ccb" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = aws_key_pair.ssh.key_name
  subnet_id      = module.network.subnets["web"].id
  security_groups = [aws_security_group.web_ccb_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "web_ccb"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = module.network.vpc_id
}

resource "aws_route" "route_ccb" {
  route_table_id = module.network.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_key_pair" "ssh" {
  key_name   = "mykey"
  public_key = file("~/.ssh/mykeytest.pub")
}

resource "aws_security_group" "web_ccb_sg" {
  name   = var.aws_sg_name
  vpc_id = module.network.vpc_id

  dynamic ingress {
    for_each = local.ingress
    content {
      from_port   = ingress.value.from_port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic egress {
    for_each = local.egress
    content {
      from_port   = egress.value.from_port
      protocol    = egress.value.protocol
      to_port     = egress.value.to_port
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}