output "id" {
  description = "The ID of the route table"
  value       = azurerm_route_table.route_table.id
}

output "name" {
  description = "The name of the route table"
  value       = azurerm_route_table.route_table.name
}

output "object" {
  description = "The data object of the route table"
  value       = azurerm_route_table.route_table
}
