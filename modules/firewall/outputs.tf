output "id" {
  value = azurerm_firewall.firewall.id
}

output "name" {
  value = azurerm_firewall.firewall.name
}

output "object" {
  value = azurerm_firewall.firewall
}

output "private_ip" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "policy_object" {
  value = module.hub_firewall_policy.object
}
