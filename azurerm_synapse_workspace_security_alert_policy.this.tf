resource "azurerm_synapse_workspace_security_alert_policy" "this" {
  count                        = var.workspace_security_alert_policy.enabled ? 1 : 0
  synapse_workspace_id         = azurerm_synapse_workspace.this.id
  policy_state                 = var.workspace_security_alert_policy.policy_state
  disabled_alerts              = var.workspace_security_alert_policy.disabled_alerts
  email_account_admins_enabled = var.workspace_security_alert_policy.email_account_admins_enabled
  email_addresses              = var.workspace_security_alert_policy.email_addresses
  retention_days               = var.workspace_security_alert_policy.retention_days
  storage_endpoint             = var.workspace_security_alert_policy.storage_endpoint
  storage_account_access_key   = var.workspace_security_alert_policy.storage_endpoint == null ? null : var.security_storage_account_access_key
}
