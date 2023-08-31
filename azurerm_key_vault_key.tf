resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  key_permissions = [
    "Create", "Get", "Delete", "Purge", "GetRotationPolicy"
  ]
}

resource "azurerm_key_vault_key" "example" {
  #checkov:skip=CKV_AZURE_112:expensive
  name         = "workspaceencryptionkey"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "unwrapKey",
    "wrapKey"
  ]
  expiration_date = time_offset.pike.rfc3339
  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}

resource "azurerm_key_vault_access_policy" "workspace_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_synapse_workspace.example.identity[0].tenant_id
  object_id    = azurerm_synapse_workspace.example.identity[0].principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]
}

resource "time_offset" "pike" {
  offset_days = 7
}
