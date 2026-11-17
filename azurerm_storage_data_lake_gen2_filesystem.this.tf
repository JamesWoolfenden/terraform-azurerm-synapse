resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = "example"
  storage_account_id = var.storage_account_id
}
