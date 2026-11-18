resource "azurerm_synapse_workspace" "this" {
  name                                 = "example"
  resource_group_name                  = var.rg_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this.id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password

  data_exfiltration_protection_enabled = var.data_exfiltration_protection_enabled
  managed_virtual_network_enabled      = var.managed_virtual_network_enabled
  public_network_access_enabled        = var.public_network_access_enabled
  azuread_authentication_only          = var.azuread_authentication_only

  customer_managed_key {
    key_versionless_id = azurerm_key_vault_key.this.versionless_id
    key_name           = "enckey"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags

  lifecycle {
    precondition {
      condition     = var.azuread_authentication_only || (var.sql_administrator_login != null && var.sql_administrator_login_password != null)
      error_message = "sql_administrator_login and sql_administrator_login_password are required when azuread_authentication_only is false."
    }
  }
}
