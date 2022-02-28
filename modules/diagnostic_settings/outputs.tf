output "id" {
  description = "The ID of the created diagnostic settings resource"
  value       = azurerm_monitor_diagnostic_setting.diagnostic_settings.id
}

output "name" {
  description = "The name of the created diagnostic settings resource"
  value       = azurerm_monitor_diagnostic_setting.diagnostic_settings.name
}

output "object" {
  description = "The data object of the created diagnostic settings resource"
  value       = azurerm_monitor_diagnostic_setting.diagnostic_settings
}
