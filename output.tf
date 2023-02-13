output "custom_vpc_id" {
  value = module.network.vpc_id
}

output "custom_subnet_id" {
  value = module.network.subnets["web"].id
}

output "custom_public_ip" {
  value = aws_instance.web_ccb.public_ip
}