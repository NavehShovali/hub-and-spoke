resource "azurerm_public_ip" "gateway" {
  name                = "${var.name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name

  generation                 = var.generation
  sku                        = var.sku
  type                       = var.type
  vpn_type                   = var.vpn_type
  active_active              = false
  private_ip_address_enabled = false

  ip_configuration {
    public_ip_address_id = azurerm_public_ip.gateway.id
    subnet_id            = var.subnet_id
  }

  vpn_client_configuration {
    address_space        = var.address_prefixes
    vpn_client_protocols = var.vpn_client_protocols
    vpn_auth_types       = var.vpn_auth_types
    aad_audience         = var.azure_active_directory_authentication.audience
    aad_issuer           = var.azure_active_directory_authentication.issuer
    aad_tenant           = var.azure_active_directory_authentication.tenant
  }
}
