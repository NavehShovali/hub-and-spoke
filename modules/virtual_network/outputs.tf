output "id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.virtual_network.id
}

output "name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.virtual_network.name
}

output "object" {
  description = "The data object of the virtual network"
  value       = azurerm_virtual_network.virtual_network
}

output "subnets" {
  description = "A map from name to data object of the virtual network's associated subnets"
  value       = {for subnet in values(azurerm_subnet.subnets) : subnet.name => subnet}
}
