output "resource_group_name" {
  value = azurerm_resource_group.example[*].name
}

output "storagename" {
  value = [for i in azurerm_storage_account.example: i.name]
}