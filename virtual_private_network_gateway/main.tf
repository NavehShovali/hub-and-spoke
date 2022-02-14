resource "azurerm_public_ip" "gateway" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_hub" "gateway" {
  location            = var.location
  name                = "${var.name}-hub"
  resource_group_name = var.resource_group_name
}

resource "azurerm_vpn_server_configuration" "gateway" {
  location                 = var.location
  name                     = var.name
  resource_group_name      = var.resource_group_name
  vpn_authentication_types = ["AAD"]

  azure_active_directory_authentication {
    audience = var.azure_active_directory_authentication.audience
    issuer   = var.azure_active_directory_authentication.issuer
    tenant   = var.azure_active_directory_authentication.tenant
  }
}

resource "azurerm_virtual_network_gateway" "gateway" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  sku                 = "VpnGw2"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  ip_configuration {
    public_ip_address_id = azurerm_public_ip.gateway.id
    subnet_id            = var.subnet_id
  }
}

resource "azurerm_point_to_site_vpn_gateway" "gateway" {
  location                    = var.location
  name                        = "${var.name}-point-to-site"
  resource_group_name         = var.resource_group_name
  scale_unit                  = 1
  virtual_hub_id              = azurerm_virtual_hub.gateway.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.gateway.id

  connection_configuration {
    name = "${var.name}-point-to-site-connection"
    vpn_client_address_pool {
      address_prefixes = var.address_prefixes
    }
  }
}
