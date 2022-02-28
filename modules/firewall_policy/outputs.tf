output "id" {
  description = "The ID of the firewall policy"
  value       = azurerm_firewall_policy.firewall_policy.id
}

output "name" {
  description = "The name of the firewall policy"
  value       = azurerm_firewall_policy.firewall_policy.name
}

output "object" {
  description = "The data object of the firewall policy"
  value       = azurerm_firewall_policy.firewall_policy
}
