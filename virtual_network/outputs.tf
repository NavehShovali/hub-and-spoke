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

output "firewall_subnet_id" {
  value = length(azurerm_subnet.firewall_subnet) > 0 ? azurerm_subnet.firewall_subnet[0].id : null
}

output "gateway_subnet_id" {
  value = length(azurerm_subnet.gateway_subnet) > 0 ? azurerm_subnet.gateway_subnet[0].id : null
}
