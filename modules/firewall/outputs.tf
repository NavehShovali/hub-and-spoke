output "id" {
  description = "The ID of the firewall"
  value       = azurerm_firewall.firewall.id
}

output "name" {
  description = "The name of the firewall"
  value       = azurerm_firewall.firewall.name
}

output "object" {
  description = "The data object the firewall"
  value       = azurerm_firewall.firewall
}

output "private_ip" {
  description = "The private IP address of the firewall"
  value       = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "policy_object" {
  description = "The data object of the firewall policy associated with the firewall"
  value       = module.hub_firewall_policy.object
}
