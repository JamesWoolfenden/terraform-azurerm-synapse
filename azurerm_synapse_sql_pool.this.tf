resource "azurerm_synapse_sql_pool" "this" {
  count                     = var.sql_pool == null ? 0 : 1
  name                      = var.sql_pool.name
  synapse_workspace_id      = azurerm_synapse_workspace.this.id
  sku_name                  = var.sql_pool.sku_name
  create_mode               = var.sql_pool.create_mode
  storage_account_type      = var.sql_pool.storage_account_type
  collation                 = var.sql_pool.collation
  data_encrypted            = var.sql_pool.data_encrypted
  geo_backup_policy_enabled = var.sql_pool.geo_backup_policy_enabled
  recovery_database_id      = var.sql_pool.recovery_database_id

  dynamic "restore" {
    for_each = var.sql_pool.restore[*]
    content {
      point_in_time      = restore.value.point_in_time
      source_database_id = restore.value.source_database_id
    }
  }

  tags = var.common_tags

  depends_on = [azurerm_synapse_workspace_key.this]
}
