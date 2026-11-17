resource "azurerm_synapse_sql_pool_extended_auditing_policy" "this" {
  count                                   = var.sql_pool != null && var.sql_pool_extended_auditing_policy.enabled ? 1 : 0
  sql_pool_id                             = azurerm_synapse_sql_pool.this[0].id
  log_monitoring_enabled                  = var.sql_pool_extended_auditing_policy.log_monitoring_enabled
  retention_in_days                       = var.sql_pool_extended_auditing_policy.retention_in_days
  storage_endpoint                        = var.sql_pool_extended_auditing_policy.storage_endpoint
  storage_account_access_key              = var.sql_pool_extended_auditing_policy.storage_endpoint == null ? null : var.security_storage_account_access_key
  storage_account_access_key_is_secondary = var.sql_pool_extended_auditing_policy.storage_endpoint == null ? null : var.sql_pool_extended_auditing_policy.storage_account_access_key_is_secondary
}
