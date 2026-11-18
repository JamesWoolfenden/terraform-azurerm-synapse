module "synapse" {
  source             = "../../"
  rg_name            = azurerm_resource_group.synapse.name
  location           = azurerm_resource_group.synapse.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  key_vault_id       = azurerm_key_vault.synapse.id
  storage_account_id = azurerm_storage_account.synapse.id
  common_tags        = var.common_tags

  public_network_access_enabled        = false
  managed_virtual_network_enabled      = true
  data_exfiltration_protection_enabled = true
  azuread_authentication_only          = true

  firewall_rules = {
    office = {
      start_ip_address = "203.0.113.0"
      end_ip_address   = "203.0.113.255"
    }
  }

  sql_pool = {
    name                      = "sqlpool"
    data_encrypted            = true
    geo_backup_policy_enabled = true
  }

  spark_pool = {
    name                           = "sparkpool"
    session_level_packages_enabled = false
    auto_pause_delay_in_minutes    = 15
    auto_scale = {
      min_node_count = 3
      max_node_count = 5
    }
  }

  workspace_security_alert_policy = {
    enabled         = true
    policy_state    = "Enabled"
    email_addresses = ["security@example.com"]
  }

  workspace_extended_auditing_policy = {
    enabled                = true
    log_monitoring_enabled = true
    retention_in_days      = 90
  }

  workspace_vulnerability_assessment = {
    storage_container_path = "${azurerm_storage_account.synapse.primary_blob_endpoint}${azurerm_storage_container.vulnerability.name}/"
    recurring_scans = {
      enabled = true
      emails  = ["security@example.com"]
    }
  }

  sql_pool_security_alert_policy = {
    enabled         = true
    policy_state    = "Enabled"
    email_addresses = ["security@example.com"]
  }

  sql_pool_extended_auditing_policy = {
    enabled                = true
    log_monitoring_enabled = true
    retention_in_days      = 90
  }

  sql_pool_vulnerability_assessment = {
    storage_container_path = "${azurerm_storage_account.synapse.primary_blob_endpoint}${azurerm_storage_container.vulnerability.name}/"
    recurring_scans = {
      enabled = true
      emails  = ["security@example.com"]
    }
  }

  sql_pool_vulnerability_assessment_baselines = {
    va1258 = {
      rule_name = "VA1258"
      baselines = [["dbo"]]
    }
  }
}

resource "azurerm_resource_group" "synapse" {
  name     = "synapse-example"
  location = "West Europe"
}

# holden:ignore:HLD_AZ_200 example scaffolding: private endpoints need a VNet/subnet and private DNS that are out of scope for this module example
# holden:ignore:HLD_AZ_085 example scaffolding: Microsoft-managed keys plus infrastructure encryption; the module itself applies a customer-managed key to the Synapse workspace
# holden:ignore:HLD_AZ_044 blob versioning is not supported on hierarchical-namespace (Data Lake Gen2) accounts, which Synapse requires
resource "azurerm_storage_account" "synapse" {
  name                              = "synapseexamplestorage"
  resource_group_name               = azurerm_resource_group.synapse.name
  location                          = azurerm_resource_group.synapse.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  account_kind                      = "StorageV2"
  is_hns_enabled                    = true
  min_tls_version                   = "TLS1_2"
  https_traffic_only_enabled        = true
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = false
  default_to_oauth_authentication   = true
  infrastructure_encryption_enabled = true
  local_user_enabled                = false
  public_network_access_enabled     = false

  sas_policy {
    expiration_period = "01.00:00:00"
    expiration_action = "Log"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_container" "vulnerability" {
  name                  = "vulnerability-assessment"
  storage_account_id    = azurerm_storage_account.synapse.id
  container_access_type = "private"
}

# holden:ignore:HLD_AZ_008 the module grants key permissions with azurerm_key_vault_access_policy, so the vault must stay in access-policy mode
# holden:ignore:HLD_AZ_200 example scaffolding: private endpoints need a VNet/subnet and private DNS that are out of scope for this module example
resource "azurerm_key_vault" "synapse" {
  name                          = "synapse-example-kv"
  location                      = azurerm_resource_group.synapse.location
  resource_group_name           = azurerm_resource_group.synapse.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = false

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

data "azurerm_client_config" "current" {}
