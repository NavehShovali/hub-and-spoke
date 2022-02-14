output "id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "data" {
  value = azurerm_virtual_network.virtual_network
}

output "subnets" {
  value = values(azurerm_subnet.subnets)
}