resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  key_permissions = [
    "Create", "Get", "Delete", "Purge", "GetRotationPolicy", "SetRotationPolicy"
  ]
}
