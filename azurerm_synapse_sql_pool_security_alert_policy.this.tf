resource "azurerm_synapse_sql_pool_security_alert_policy" "this" {
  count                        = var.sql_pool != null && var.sql_pool_security_alert_policy.enabled ? 1 : 0
  sql_pool_id                  = azurerm_synapse_sql_pool.this[0].id
  policy_state                 = var.sql_pool_security_alert_policy.policy_state
  disabled_alerts              = var.sql_pool_security_alert_policy.disabled_alerts
  email_account_admins_enabled = var.sql_pool_security_alert_policy.email_account_admins_enabled
  email_addresses              = var.sql_pool_security_alert_policy.email_addresses
  retention_days               = var.sql_pool_security_alert_policy.retention_days
  storage_endpoint             = var.sql_pool_security_alert_policy.storage_endpoint
  storage_account_access_key   = var.sql_pool_security_alert_policy.storage_endpoint == null ? null : var.security_storage_account_access_key
}
