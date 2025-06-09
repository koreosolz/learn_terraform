output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_addresses" {
  value = {
    for name, pip in azurerm_public_ip.public_ip :
    name => pip.ip_address
  }
}