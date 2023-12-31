module "synapse" {
  source             = "../../"
  rg_name            = azurerm_resource_group.example.name
  location           = azurerm_resource_group.example.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  key_vault_id       = azurerm_key_vault.example.id
  storage_account_id = azurerm_storage_account.example.id
  common_tags        = var.common_tags
}


resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  #checkov:skip=CKV2_AZURE_33:example
  #checkov:skip=CKV2_AZURE_1:example
  #checkov:skip=CKV2_AZURE_38:example
  #checkov:skip=CKV_AZURE_190:example
  #checkov:skip=CKV_AZURE_206:example
  #checkov:skip=CKV_AZURE_44:example
  #checkov:skip=CKV_AZURE_59:example
  #checkov:skip=CKV_AZURE_33:example
  name                     = "examplestorageacc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_key_vault" "example" {
  #checkov:skip=CKV2_AZURE_32:example
  #checkov:skip=CKV_AZURE_109:example
  #checkov:skip=CKV_AZURE_189:example
  name                     = "example"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
}

data "azurerm_client_config" "current" {}
