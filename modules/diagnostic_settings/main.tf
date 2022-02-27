data "azurerm_monitor_diagnostic_categories" "resource_categories" {
  resource_id = var.target_resource_id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                       = "${var.target_resource_name}-diagnostic-settings"
  target_resource_id         = var.target_resource_id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.resource_categories.logs)

    content {
      category = log.key
    }
  }
}
