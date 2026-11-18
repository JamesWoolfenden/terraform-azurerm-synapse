# required
variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)

  validation {
    condition     = length(var.common_tags) <= 50
    error_message = "Azure resources support at most 50 tags."
  }
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault holding the workspace customer-managed key"
  type        = string

  validation {
    condition     = can(regex("(?i)^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.KeyVault/vaults/[^/]+$", var.key_vault_id))
    error_message = "key_vault_id must be a Key Vault resource ID."
  }
}

variable "tenant_id" {
  description = "Azure AD tenant ID of the identity deploying the module"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "tenant_id must be a GUID."
  }
}

variable "object_id" {
  description = "Object ID of the identity deploying the module, granted key permissions on the Key Vault"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.object_id))
    error_message = "object_id must be a GUID."
  }
}

variable "rg_name" {
  description = "Name of the resource group the workspace is created in"
  type        = string

  validation {
    condition     = length(var.rg_name) > 0 && length(var.rg_name) <= 90
    error_message = "rg_name must be 1-90 characters."
  }
}

variable "location" {
  description = "Azure region for the workspace"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "location must not be empty."
  }
}

variable "storage_account_id" {
  description = "Resource ID of the Data Lake Gen2 (hierarchical namespace) storage account used by the workspace"
  type        = string

  validation {
    condition     = can(regex("(?i)^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Storage/storageAccounts/[^/]+$", var.storage_account_id))
    error_message = "storage_account_id must be a storage account resource ID."
  }
}

variable "azuread_authentication_only" {
  description = "Allow only Azure AD authentication to the workspace SQL endpoints, disabling SQL (password) authentication"
  type        = bool
  default     = true
}

variable "sql_administrator_login" {
  description = "SQL administrator login. Only needed when azuread_authentication_only is false"
  type        = string
  default     = null

  validation {
    condition     = var.sql_administrator_login == null || can(regex("^[A-Za-z][A-Za-z0-9_]{0,127}$", var.sql_administrator_login))
    error_message = "sql_administrator_login must start with a letter and contain only letters, digits and underscores (max 128 characters)."
  }
}

variable "sql_administrator_login_password" {
  description = "SQL administrator password. Only needed when azuread_authentication_only is false; source it from a secret store, never a literal"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.sql_administrator_login_password == null || length(coalesce(var.sql_administrator_login_password, "")) >= 12
    error_message = "sql_administrator_login_password must be at least 12 characters."
  }
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the Synapse workspace endpoints. Firewall rules only take effect when this is true"
  type        = bool
  default     = false
}

variable "managed_virtual_network_enabled" {
  description = "Deploy the workspace into a Synapse managed virtual network (required for data exfiltration protection)"
  type        = bool
  default     = true
}

variable "data_exfiltration_protection_enabled" {
  description = "Restrict outbound traffic from the managed virtual network to approved managed private endpoints only"
  type        = bool
  default     = true
}

variable "firewall_rules" {
  description = "Map of workspace firewall rules keyed by rule name. Empty by default (no IP ranges allowed)"
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.firewall_rules) :
      !(rule.start_ip_address == "0.0.0.0" && rule.end_ip_address == "255.255.255.255")
    ])
    error_message = "A firewall rule may not allow the entire IPv4 range (0.0.0.0 - 255.255.255.255)."
  }
}

variable "sql_pool" {
  description = "Dedicated SQL pool settings. Leave null to not create a SQL pool"
  type = object({
    name                      = optional(string, "sqlpool")
    sku_name                  = optional(string, "DW100c")
    create_mode               = optional(string, "Default")
    storage_account_type      = optional(string, "GRS")
    collation                 = optional(string)
    data_encrypted            = optional(bool, true)
    geo_backup_policy_enabled = optional(bool, true)
    recovery_database_id      = optional(string)
    restore = optional(object({
      point_in_time      = string
      source_database_id = string
    }))
  })
  default = null

  validation {
    condition = var.sql_pool == null ? true : (
      can(regex("^DW[0-9]+c$", var.sql_pool.sku_name)) &&
      contains(["LRS", "GRS"], var.sql_pool.storage_account_type) &&
      contains(["Default", "Recovery", "PointInTimeRestore"], var.sql_pool.create_mode)
    )
    error_message = "sql_pool.sku_name must look like DW100c, storage_account_type must be LRS or GRS and create_mode must be Default, Recovery or PointInTimeRestore."
  }
}

variable "spark_pool" {
  description = "Apache Spark pool settings. Leave null to not create a Spark pool"
  type = object({
    name                                = optional(string, "sparkpool")
    node_size_family                    = optional(string, "MemoryOptimized")
    node_size                           = optional(string, "Small")
    spark_version                       = optional(string, "3.4")
    node_count                          = optional(number, 3)
    cache_size                          = optional(number)
    compute_isolation_enabled           = optional(bool, false)
    dynamic_executor_allocation_enabled = optional(bool, false)
    min_executors                       = optional(number)
    max_executors                       = optional(number)
    session_level_packages_enabled      = optional(bool, false)
    spark_log_folder                    = optional(string, "/logs")
    spark_events_folder                 = optional(string, "/events")
    auto_pause_delay_in_minutes         = optional(number, 15)
    auto_scale = optional(object({
      min_node_count = number
      max_node_count = number
    }))
    library_requirement = optional(object({
      content  = string
      filename = string
    }))
    spark_config = optional(object({
      content  = string
      filename = string
    }))
  })
  default = null

  validation {
    condition = var.spark_pool == null ? true : (
      contains(["None", "MemoryOptimized", "HardwareAcceleratedFPGA", "HardwareAcceleratedGPU"], var.spark_pool.node_size_family) &&
      contains(["Small", "Medium", "Large", "XLarge", "XXLarge", "XXXLarge", "None"], var.spark_pool.node_size) &&
      var.spark_pool.auto_pause_delay_in_minutes >= 5 && var.spark_pool.auto_pause_delay_in_minutes <= 10080
    )
    error_message = "spark_pool.node_size_family/node_size must be valid Synapse values and auto_pause_delay_in_minutes must be between 5 and 10080."
  }
}

variable "security_storage_account_access_key" {
  description = "Optional storage account access key used by the auditing, alert and vulnerability assessment policies. Prefer managed identity access and leave null"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.security_storage_account_access_key == null ? true : length(var.security_storage_account_access_key) > 0
    error_message = "security_storage_account_access_key must be null or a non-empty key."
  }
}

variable "workspace_security_alert_policy" {
  description = "Workspace-level threat detection (security alert) policy. Enabled by default"
  type = object({
    enabled                      = optional(bool, true)
    policy_state                 = optional(string, "Enabled")
    disabled_alerts              = optional(set(string), [])
    email_account_admins_enabled = optional(bool, true)
    email_addresses              = optional(set(string), [])
    retention_days               = optional(number, 90)
    storage_endpoint             = optional(string)
  })
  default = {}

  validation {
    condition     = contains(["Enabled", "Disabled", "New"], var.workspace_security_alert_policy.policy_state) && var.workspace_security_alert_policy.retention_days >= 0
    error_message = "policy_state must be Enabled, Disabled or New and retention_days must not be negative."
  }
}

variable "workspace_extended_auditing_policy" {
  description = "Workspace-level extended auditing policy. Enabled by default, logging to Azure Monitor"
  type = object({
    enabled                                 = optional(bool, true)
    log_monitoring_enabled                  = optional(bool, true)
    retention_in_days                       = optional(number, 90)
    storage_endpoint                        = optional(string)
    storage_account_access_key_is_secondary = optional(bool, false)
  })
  default = {}

  validation {
    condition     = var.workspace_extended_auditing_policy.retention_in_days >= 0 && var.workspace_extended_auditing_policy.retention_in_days <= 3285
    error_message = "retention_in_days must be between 0 and 3285."
  }
}

variable "workspace_vulnerability_assessment" {
  description = "Workspace-level vulnerability assessment. Requires a storage container path; null disables it"
  type = object({
    storage_container_path    = string
    storage_container_sas_key = optional(string)
    recurring_scans = optional(object({
      enabled                           = optional(bool, true)
      email_subscription_admins_enabled = optional(bool, true)
      emails                            = optional(list(string), [])
    }), {})
  })
  default = null

  validation {
    condition     = var.workspace_vulnerability_assessment == null ? true : can(regex("^https://", var.workspace_vulnerability_assessment.storage_container_path))
    error_message = "storage_container_path must be an https:// blob container URL."
  }
}

variable "sql_pool_security_alert_policy" {
  description = "SQL pool threat detection (security alert) policy. Enabled by default when a SQL pool is created"
  type = object({
    enabled                      = optional(bool, true)
    policy_state                 = optional(string, "Enabled")
    disabled_alerts              = optional(set(string), [])
    email_account_admins_enabled = optional(bool, true)
    email_addresses              = optional(set(string), [])
    retention_days               = optional(number, 90)
    storage_endpoint             = optional(string)
  })
  default = {}

  validation {
    condition     = contains(["Enabled", "Disabled", "New"], var.sql_pool_security_alert_policy.policy_state) && var.sql_pool_security_alert_policy.retention_days >= 0
    error_message = "policy_state must be Enabled, Disabled or New and retention_days must not be negative."
  }
}

variable "sql_pool_extended_auditing_policy" {
  description = "SQL pool extended auditing policy. Enabled by default when a SQL pool is created, logging to Azure Monitor"
  type = object({
    enabled                                 = optional(bool, true)
    log_monitoring_enabled                  = optional(bool, true)
    retention_in_days                       = optional(number, 90)
    storage_endpoint                        = optional(string)
    storage_account_access_key_is_secondary = optional(bool, false)
  })
  default = {}

  validation {
    condition     = var.sql_pool_extended_auditing_policy.retention_in_days >= 0 && var.sql_pool_extended_auditing_policy.retention_in_days <= 3285
    error_message = "retention_in_days must be between 0 and 3285."
  }
}

variable "sql_pool_vulnerability_assessment" {
  description = "SQL pool vulnerability assessment. Requires a storage container path; null disables it"
  type = object({
    storage_container_path    = string
    storage_container_sas_key = optional(string)
    recurring_scans = optional(object({
      enabled                           = optional(bool, true)
      email_subscription_admins_enabled = optional(bool, true)
      emails                            = optional(list(string), [])
    }), {})
  })
  default = null

  validation {
    condition     = var.sql_pool_vulnerability_assessment == null ? true : can(regex("^https://", var.sql_pool_vulnerability_assessment.storage_container_path))
    error_message = "storage_container_path must be an https:// blob container URL."
  }
}

variable "sql_pool_vulnerability_assessment_baselines" {
  description = "Map of SQL pool vulnerability assessment rule baselines; only applied when the SQL pool vulnerability assessment exists"
  type = map(object({
    rule_name = string
    name      = optional(string, "default")
    baselines = list(list(string))
  }))
  default = {}

  validation {
    condition     = alltrue([for b in values(var.sql_pool_vulnerability_assessment_baselines) : length(b.rule_name) > 0])
    error_message = "Each baseline must name a rule_name."
  }
}
