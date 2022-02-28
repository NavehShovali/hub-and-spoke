output "id" {
  description = "The ID of the created workspace"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "name" {
  description = "The name of the created workspace"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.name
}

output "object" {
  description = "The data object of the created workspace"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace
}
