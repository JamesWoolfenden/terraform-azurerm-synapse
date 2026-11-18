resource "azurerm_synapse_workspace_extended_auditing_policy" "this" {
  count                                   = var.workspace_extended_auditing_policy.enabled ? 1 : 0
  synapse_workspace_id                    = azurerm_synapse_workspace.this.id
  log_monitoring_enabled                  = var.workspace_extended_auditing_policy.log_monitoring_enabled
  retention_in_days                       = var.workspace_extended_auditing_policy.retention_in_days
  storage_endpoint                        = var.workspace_extended_auditing_policy.storage_endpoint
  storage_account_access_key              = var.workspace_extended_auditing_policy.storage_endpoint == null ? null : var.security_storage_account_access_key
  storage_account_access_key_is_secondary = var.workspace_extended_auditing_policy.storage_endpoint == null ? null : var.workspace_extended_auditing_policy.storage_account_access_key_is_secondary
}
