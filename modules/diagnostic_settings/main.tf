resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name               = "${var.target_resource_name}-diagnostic-settings"
  target_resource_id = var.target_resource_id
  storage_account_id = var.storage_account_id

  dynamic "log" {
    for_each = toset(var.log_categories)

    content {
      category = log.key
    }
  }
}
