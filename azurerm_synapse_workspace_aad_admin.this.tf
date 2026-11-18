resource "azurerm_synapse_workspace_aad_admin" "this" {
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  login                = "AzureAD Admin"
  object_id            = "00000000-0000-0000-0000-000000000000"
  tenant_id            = "00000000-0000-0000-0000-000000000000"

  depends_on = [azurerm_synapse_workspace_key.this]
}
