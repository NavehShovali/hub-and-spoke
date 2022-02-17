resource "azurerm_public_ip" "gateway" {
  allocation_method   = "Dynamic"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network_gateway" "gateway" {
  location                   = var.location
  name                       = var.name
  resource_group_name        = var.resource_group_name
  generation                 = "Generation2"
  sku                        = "VpnGw2"
  type                       = "Vpn"
  vpn_type                   = "RouteBased"
  active_active              = false
  private_ip_address_enabled = false

  ip_configuration {
    public_ip_address_id = azurerm_public_ip.gateway.id
    subnet_id            = var.subnet_id
  }

  vpn_client_configuration {
    address_space        = var.address_prefixes
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_audience         = var.azure_active_directory_authentication.audience
    aad_issuer           = var.azure_active_directory_authentication.issuer
    aad_tenant           = var.azure_active_directory_authentication.tenant
  }
}
