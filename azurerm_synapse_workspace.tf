resource "azurerm_synapse_workspace" "example" {
  name                                 = "example"
  resource_group_name                  = var.rg_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"

  data_exfiltration_protection_enabled = true
  managed_virtual_network_enabled      = true
  customer_managed_key {
    key_versionless_id = azurerm_key_vault_key.example.versionless_id
    key_name           = "enckey"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}



resource "azurerm_synapse_workspace_key" "example" {
  customer_managed_key_versionless_id = azurerm_key_vault_key.example.versionless_id
  synapse_workspace_id                = azurerm_synapse_workspace.example.id
  active                              = true
  customer_managed_key_name           = "enckey"
  depends_on                          = [azurerm_key_vault_access_policy.workspace_policy]
}

resource "azurerm_synapse_workspace_aad_admin" "example" {
  synapse_workspace_id = azurerm_synapse_workspace.example.id
  login                = "AzureAD Admin"
  object_id            = "00000000-0000-0000-0000-000000000000"
  tenant_id            = "00000000-0000-0000-0000-000000000000"

  depends_on = [azurerm_synapse_workspace_key.example]
}
