module "log_analytics_workspace" {
  source = "../modules/logs_analytics_workspace"

  location            = "westeurope"
  name                = "example-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.example.name
}
