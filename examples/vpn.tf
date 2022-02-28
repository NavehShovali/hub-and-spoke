variable "azure_active_directory_authentication" {
  description = "The virtual private network's AAD credentials"
  sensitive   = true
  type        = object({
    audience = string
    issuer   = string
    tenant   = string
  })
}

module "virtual_private_network_gateway" {
  source = "../modules/virtual_private_network_gateway"

  name                = "example-vpn"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  address_prefixes                      = ["10.2.0.0/24"]
  azure_active_directory_authentication = var.azure_active_directory_authentication
  subnet_id                             = module.virtual_network_with_gateway.subnets.GatewaySubnet.id

  depends_on = [module.virtual_network_with_gateway]
}
