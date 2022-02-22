output "id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.security_group.id
}

output "name" {
  description = "The name of the network security group"
  value = azurerm_network_security_group.security_group.name
}

output "object" {
  description = "The data object of the network security group"
  value       = azurerm_network_security_group.security_group
}
