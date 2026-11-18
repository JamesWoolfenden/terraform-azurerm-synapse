resource "azurerm_key_vault_access_policy" "workspace_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_synapse_workspace.this.identity[0].tenant_id
  object_id    = azurerm_synapse_workspace.this.identity[0].principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]
}
