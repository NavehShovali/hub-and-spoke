output "id" {
  description = "The ID of the VPN gateway"
  value       = azurerm_virtual_network_gateway.gateway.id
}

output "name" {
  description = "The name of the VPN gateway"
  value       = azurerm_virtual_network_gateway.gateway.name
}

output "object" {
  description = "The data object of the VPN gateway"
  value       = azurerm_virtual_network_gateway.gateway
}
