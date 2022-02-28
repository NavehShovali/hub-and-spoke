locals {
  security_rules = {
    allow-ssh-to-default = {
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 300
      protocol                   = "TCP"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "10.0.0.0/25"
    }
  }
}

module "example_network_security_group" {
  source = "../modules/network_security_group"

  name                = "example-network-security-group"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  security_rules = local.security_rules
  subnet_id      = module.virtual_network1.subnets.default.id

  depends_on = [module.virtual_network1]
}
