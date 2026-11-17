resource "azurerm_synapse_workspace_key" "this" {
  customer_managed_key_versionless_id = azurerm_key_vault_key.this.versionless_id
  synapse_workspace_id                = azurerm_synapse_workspace.this.id
  active                              = true
  customer_managed_key_name           = "enckey"
  depends_on                          = [azurerm_key_vault_access_policy.workspace_policy]
}
