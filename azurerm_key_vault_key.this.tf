# holden:ignore:HLD_AZ_163 HSM-backed keys need a Premium Key Vault; the vault is caller-supplied (var.key_vault_id) and may be Standard tier
resource "azurerm_key_vault_key" "this" {
  name         = "workspaceencryptionkey"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "unwrapKey",
    "wrapKey"
  ]
  expiration_date = time_offset.pike.rfc3339

  rotation_policy {
    expire_after         = "P90D"
    notify_before_expiry = "P29D"

    automatic {
      time_before_expiry = "P30D"
    }
  }

  depends_on = [
    azurerm_key_vault_access_policy.deployer
  ]
}
