module "virtual_network_diagnostic_settings" {
  source = "../modules/diagnostic_settings"

  log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_name       = module.virtual_network1.name
  target_resource_id         = module.virtual_network1.id

  depends_on = [module.log_analytics_workspace, module.virtual_network1]
}
