output "id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "object" {
  value = azurerm_virtual_network.virtual_network
}

output "subnets" {
  value = {for subnet in values(azurerm_subnet.subnets) : subnet.name => subnet}
}
