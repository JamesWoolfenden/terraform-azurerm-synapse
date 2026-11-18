# terraform-azurerm-synapse

With Secure Defaults

[![Build Status](https://github.com/JamesWoolfenden/terraform-azurerm-synapse/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-azurerm-synapse)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-azurerm-synapse.svg)](https://github.com/JamesWoolfenden/terraform-azurerm-synapse/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-azurerm-synapse.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-azurerm-synapse/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.14.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module - Azure Synapse Analytics workspace with optional dedicated SQL pool, Apache Spark pool,
firewall rules and workspace/SQL pool security policies (threat detection, extended auditing and vulnerability assessment).

Secure defaults:

- public network access disabled, managed virtual network and data exfiltration protection enabled
- Azure AD-only authentication
- customer-managed key encryption for the workspace, transparent data encryption and geo-backup for SQL pools
- workspace and SQL pool security alert and extended auditing policies enabled
- Spark session-level package installation disabled, auto-pause always configured
- no firewall rules by default; a rule covering the whole IPv4 range is rejected

---

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

## Usage

This is a very basic example.

Include **module.synapse.tf** this repository as a module in your existing Terraform code:

```terraform
module "synapse" {
  source             = "JamesWoolfenden/synapse/azurerm"
  version            = "v0.1.1"
  rg_name            = azurerm_resource_group.synapse.name
  location           = azurerm_resource_group.synapse.location
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  key_vault_id       = azurerm_key_vault.synapse.id
  storage_account_id = azurerm_storage_account.synapse.id
  common_tags        = var.common_tags

  sql_pool   = {}
  spark_pool = {}
}
```

The SQL pool, Spark pool and vulnerability assessments are only created when their variables are set (see **example/examplea**).
The security alert and extended auditing policies are created by default; set `enabled = false` in their objects to opt out.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_key_vault_access_policy.deployer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.workspace_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_storage_data_lake_gen2_filesystem.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [azurerm_synapse_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_firewall_rule) | resource |
| [azurerm_synapse_spark_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_spark_pool) | resource |
| [azurerm_synapse_sql_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool) | resource |
| [azurerm_synapse_sql_pool_extended_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool_extended_auditing_policy) | resource |
| [azurerm_synapse_sql_pool_security_alert_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool_security_alert_policy) | resource |
| [azurerm_synapse_sql_pool_vulnerability_assessment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool_vulnerability_assessment) | resource |
| [azurerm_synapse_sql_pool_vulnerability_assessment_baseline.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool_vulnerability_assessment_baseline) | resource |
| [azurerm_synapse_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace) | resource |
| [azurerm_synapse_workspace_aad_admin.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_aad_admin) | resource |
| [azurerm_synapse_workspace_extended_auditing_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_extended_auditing_policy) | resource |
| [azurerm_synapse_workspace_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_key) | resource |
| [azurerm_synapse_workspace_security_alert_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_security_alert_policy) | resource |
| [azurerm_synapse_workspace_vulnerability_assessment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace_vulnerability_assessment) | resource |
| [time_offset.pike](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Allow only Azure AD authentication to the workspace SQL endpoints, disabling SQL (password) authentication | `bool` | `true` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | This is to help you add tags to your cloud objects | `map(any)` | n/a | yes |
| <a name="input_data_exfiltration_protection_enabled"></a> [data\_exfiltration\_protection\_enabled](#input\_data\_exfiltration\_protection\_enabled) | Restrict outbound traffic from the managed virtual network to approved managed private endpoints only | `bool` | `true` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Map of workspace firewall rules keyed by rule name. Empty by default (no IP ranges allowed) | <pre>map(object({<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Resource ID of the Key Vault holding the workspace customer-managed key | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the workspace | `string` | n/a | yes |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Deploy the workspace into a Synapse managed virtual network (required for data exfiltration protection) | `bool` | `true` | no |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | Object ID of the identity deploying the module, granted key permissions on the Key Vault | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public network access to the Synapse workspace endpoints. Firewall rules only take effect when this is true | `bool` | `false` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the resource group the workspace is created in | `string` | n/a | yes |
| <a name="input_security_storage_account_access_key"></a> [security\_storage\_account\_access\_key](#input\_security\_storage\_account\_access\_key) | Optional storage account access key used by the auditing, alert and vulnerability assessment policies. Prefer managed identity access and leave null | `string` | `null` | no |
| <a name="input_spark_pool"></a> [spark\_pool](#input\_spark\_pool) | Apache Spark pool settings. Leave null to not create a Spark pool | <pre>object({<br/>    name                                = optional(string, "sparkpool")<br/>    node_size_family                    = optional(string, "MemoryOptimized")<br/>    node_size                           = optional(string, "Small")<br/>    spark_version                       = optional(string, "3.4")<br/>    node_count                          = optional(number, 3)<br/>    cache_size                          = optional(number)<br/>    compute_isolation_enabled           = optional(bool, false)<br/>    dynamic_executor_allocation_enabled = optional(bool, false)<br/>    min_executors                       = optional(number)<br/>    max_executors                       = optional(number)<br/>    session_level_packages_enabled      = optional(bool, false)<br/>    spark_log_folder                    = optional(string, "/logs")<br/>    spark_events_folder                 = optional(string, "/events")<br/>    auto_pause_delay_in_minutes         = optional(number, 15)<br/>    auto_scale = optional(object({<br/>      min_node_count = number<br/>      max_node_count = number<br/>    }))<br/>    library_requirement = optional(object({<br/>      content  = string<br/>      filename = string<br/>    }))<br/>    spark_config = optional(object({<br/>      content  = string<br/>      filename = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_sql_administrator_login"></a> [sql\_administrator\_login](#input\_sql\_administrator\_login) | SQL administrator login. Only needed when azuread\_authentication\_only is false | `string` | `null` | no |
| <a name="input_sql_administrator_login_password"></a> [sql\_administrator\_login\_password](#input\_sql\_administrator\_login\_password) | SQL administrator password. Only needed when azuread\_authentication\_only is false; source it from a secret store, never a literal | `string` | `null` | no |
| <a name="input_sql_pool"></a> [sql\_pool](#input\_sql\_pool) | Dedicated SQL pool settings. Leave null to not create a SQL pool | <pre>object({<br/>    name                      = optional(string, "sqlpool")<br/>    sku_name                  = optional(string, "DW100c")<br/>    create_mode               = optional(string, "Default")<br/>    storage_account_type      = optional(string, "GRS")<br/>    collation                 = optional(string)<br/>    data_encrypted            = optional(bool, true)<br/>    geo_backup_policy_enabled = optional(bool, true)<br/>    recovery_database_id      = optional(string)<br/>    restore = optional(object({<br/>      point_in_time      = string<br/>      source_database_id = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_sql_pool_extended_auditing_policy"></a> [sql\_pool\_extended\_auditing\_policy](#input\_sql\_pool\_extended\_auditing\_policy) | SQL pool extended auditing policy. Enabled by default when a SQL pool is created, logging to Azure Monitor | <pre>object({<br/>    enabled                                 = optional(bool, true)<br/>    log_monitoring_enabled                  = optional(bool, true)<br/>    retention_in_days                       = optional(number, 90)<br/>    storage_endpoint                        = optional(string)<br/>    storage_account_access_key_is_secondary = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_sql_pool_security_alert_policy"></a> [sql\_pool\_security\_alert\_policy](#input\_sql\_pool\_security\_alert\_policy) | SQL pool threat detection (security alert) policy. Enabled by default when a SQL pool is created | <pre>object({<br/>    enabled                      = optional(bool, true)<br/>    policy_state                 = optional(string, "Enabled")<br/>    disabled_alerts              = optional(set(string), [])<br/>    email_account_admins_enabled = optional(bool, true)<br/>    email_addresses              = optional(set(string), [])<br/>    retention_days               = optional(number, 90)<br/>    storage_endpoint             = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_sql_pool_vulnerability_assessment"></a> [sql\_pool\_vulnerability\_assessment](#input\_sql\_pool\_vulnerability\_assessment) | SQL pool vulnerability assessment. Requires a storage container path; null disables it | <pre>object({<br/>    storage_container_path    = string<br/>    storage_container_sas_key = optional(string)<br/>    recurring_scans = optional(object({<br/>      enabled                           = optional(bool, true)<br/>      email_subscription_admins_enabled = optional(bool, true)<br/>      emails                            = optional(list(string), [])<br/>    }), {})<br/>  })</pre> | `null` | no |
| <a name="input_sql_pool_vulnerability_assessment_baselines"></a> [sql\_pool\_vulnerability\_assessment\_baselines](#input\_sql\_pool\_vulnerability\_assessment\_baselines) | Map of SQL pool vulnerability assessment rule baselines; only applied when the SQL pool vulnerability assessment exists | <pre>map(object({<br/>    rule_name = string<br/>    name      = optional(string, "default")<br/>    baselines = list(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Resource ID of the Data Lake Gen2 (hierarchical namespace) storage account used by the workspace | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD tenant ID of the identity deploying the module | `string` | n/a | yes |
| <a name="input_workspace_extended_auditing_policy"></a> [workspace\_extended\_auditing\_policy](#input\_workspace\_extended\_auditing\_policy) | Workspace-level extended auditing policy. Enabled by default, logging to Azure Monitor | <pre>object({<br/>    enabled                                 = optional(bool, true)<br/>    log_monitoring_enabled                  = optional(bool, true)<br/>    retention_in_days                       = optional(number, 90)<br/>    storage_endpoint                        = optional(string)<br/>    storage_account_access_key_is_secondary = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_workspace_security_alert_policy"></a> [workspace\_security\_alert\_policy](#input\_workspace\_security\_alert\_policy) | Workspace-level threat detection (security alert) policy. Enabled by default | <pre>object({<br/>    enabled                      = optional(bool, true)<br/>    policy_state                 = optional(string, "Enabled")<br/>    disabled_alerts              = optional(set(string), [])<br/>    email_account_admins_enabled = optional(bool, true)<br/>    email_addresses              = optional(set(string), [])<br/>    retention_days               = optional(number, 90)<br/>    storage_endpoint             = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_workspace_vulnerability_assessment"></a> [workspace\_vulnerability\_assessment](#input\_workspace\_vulnerability\_assessment) | Workspace-level vulnerability assessment. Requires a storage container path; null disables it | <pre>object({<br/>    storage_container_path    = string<br/>    storage_container_sas_key = optional(string)<br/>    recurring_scans = optional(object({<br/>      enabled                           = optional(bool, true)<br/>      email_subscription_admins_enabled = optional(bool, true)<br/>      emails                            = optional(list(string), [])<br/>    }), {})<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall_rules"></a> [firewall\_rules](#output\_firewall\_rules) | The workspace firewall rules |
| <a name="output_spark_pool"></a> [spark\_pool](#output\_spark\_pool) | The Apache Spark pool (null when not created) |
| <a name="output_sql_pool"></a> [sql\_pool](#output\_sql\_pool) | The dedicated SQL pool (null when not created) |
| <a name="output_sql_pool_extended_auditing_policy"></a> [sql\_pool\_extended\_auditing\_policy](#output\_sql\_pool\_extended\_auditing\_policy) | The SQL pool extended auditing policy |
| <a name="output_sql_pool_security_alert_policy"></a> [sql\_pool\_security\_alert\_policy](#output\_sql\_pool\_security\_alert\_policy) | The SQL pool security alert policy |
| <a name="output_sql_pool_vulnerability_assessment"></a> [sql\_pool\_vulnerability\_assessment](#output\_sql\_pool\_vulnerability\_assessment) | The SQL pool vulnerability assessment |
| <a name="output_sql_pool_vulnerability_assessment_baselines"></a> [sql\_pool\_vulnerability\_assessment\_baselines](#output\_sql\_pool\_vulnerability\_assessment\_baselines) | The SQL pool vulnerability assessment baselines |
| <a name="output_workspace_extended_auditing_policy"></a> [workspace\_extended\_auditing\_policy](#output\_workspace\_extended\_auditing\_policy) | The workspace extended auditing policy |
| <a name="output_workspace_security_alert_policy"></a> [workspace\_security\_alert\_policy](#output\_workspace\_security\_alert\_policy) | The workspace security alert policy |
| <a name="output_workspace_vulnerability_assessment"></a> [workspace\_vulnerability\_assessment](#output\_workspace\_vulnerability\_assessment) | The workspace vulnerability assessment |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Policy

This is the policy required to build this project:

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang

# apply role — full permissions for terraform apply
# Bind this role to the applier SA on protected branches only.
resource "azurerm_role_definition" "terraform_pike" {
  role_definition_id = local.apply_uuid
  name               = "terraform_pike"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.KeyVault/vaults/accessPolicies/write",
    "Microsoft.KeyVault/vaults/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Storage/storageAccounts/read",
    "Microsoft.Synapse/workspaces/administrators/delete",
    "Microsoft.Synapse/workspaces/administrators/read",
    "Microsoft.Synapse/workspaces/administrators/write",
    "Microsoft.Synapse/workspaces/bigDataPools/delete",
    "Microsoft.Synapse/workspaces/bigDataPools/read",
    "Microsoft.Synapse/workspaces/bigDataPools/write",
    "Microsoft.Synapse/workspaces/delete",
    "Microsoft.Synapse/workspaces/extendedAuditingSettings/read",
    "Microsoft.Synapse/workspaces/extendedAuditingSettings/write",
    "Microsoft.Synapse/workspaces/firewallRules/delete",
    "Microsoft.Synapse/workspaces/firewallRules/read",
    "Microsoft.Synapse/workspaces/firewallRules/write",
    "Microsoft.Synapse/workspaces/keys/delete",
    "Microsoft.Synapse/workspaces/keys/read",
    "Microsoft.Synapse/workspaces/keys/write",
    "Microsoft.Synapse/workspaces/operationResults/read",
    "Microsoft.Synapse/workspaces/operationStatuses/read",
    "Microsoft.Synapse/workspaces/read",
    "Microsoft.Synapse/workspaces/securityAlertPolicies/read",
    "Microsoft.Synapse/workspaces/securityAlertPolicies/write",
    "Microsoft.Synapse/workspaces/sqlPools/delete",
    "Microsoft.Synapse/workspaces/sqlPools/extendedAuditingSettings/read",
    "Microsoft.Synapse/workspaces/sqlPools/extendedAuditingSettings/write",
    "Microsoft.Synapse/workspaces/sqlPools/operationResults/read",
    "Microsoft.Synapse/workspaces/sqlPools/operationStatuses/read",
    "Microsoft.Synapse/workspaces/sqlPools/read",
    "Microsoft.Synapse/workspaces/sqlPools/securityAlertPolicies/read",
    "Microsoft.Synapse/workspaces/sqlPools/securityAlertPolicies/write",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/delete",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/read",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/rules/baselines/delete",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/rules/baselines/read",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/rules/baselines/write",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/write",
    "Microsoft.Synapse/workspaces/sqlPools/write",
    "Microsoft.Synapse/workspaces/vulnerabilityAssessments/delete",
    "Microsoft.Synapse/workspaces/vulnerabilityAssessments/read",
    "Microsoft.Synapse/workspaces/vulnerabilityAssessments/write",
    "Microsoft.Synapse/workspaces/write"]
    not_actions = []
  }

  assignable_scopes = [data.azurerm_subscription.primary.id]
}

# plan role — read-only permissions for terraform plan
# Bind this role to the planner SA on all branches.
resource "azurerm_role_definition" "terraform_pike_plan" {
  role_definition_id = local.plan_uuid
  name               = "terraform_pike_plan"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.KeyVault/vaults/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Storage/storageAccounts/read",
    "Microsoft.Synapse/workspaces/administrators/read",
    "Microsoft.Synapse/workspaces/bigDataPools/read",
    "Microsoft.Synapse/workspaces/extendedAuditingSettings/read",
    "Microsoft.Synapse/workspaces/firewallRules/read",
    "Microsoft.Synapse/workspaces/keys/read",
    "Microsoft.Synapse/workspaces/operationResults/read",
    "Microsoft.Synapse/workspaces/operationStatuses/read",
    "Microsoft.Synapse/workspaces/read",
    "Microsoft.Synapse/workspaces/securityAlertPolicies/read",
    "Microsoft.Synapse/workspaces/sqlPools/extendedAuditingSettings/read",
    "Microsoft.Synapse/workspaces/sqlPools/operationResults/read",
    "Microsoft.Synapse/workspaces/sqlPools/operationStatuses/read",
    "Microsoft.Synapse/workspaces/sqlPools/read",
    "Microsoft.Synapse/workspaces/sqlPools/securityAlertPolicies/read",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/read",
    "Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments/rules/baselines/read",
    "Microsoft.Synapse/workspaces/vulnerabilityAssessments/read"]
    not_actions = []
  }

  assignable_scopes = [data.azurerm_subscription.primary.id]
}

locals {
  apply_uuid = uuid()
  plan_uuid  = uuid()
}

data "azurerm_subscription" "primary" {}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

Check out these related projects.

- [terraform-aws-s3](https://github.com/jameswoolfenden/terraform-aws-s3) - S3 buckets

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-azurerm-synapse/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-azurerm-synapse/issues) to report any bugs or file feature requests.

## Copyrights

Copyright 2022-23 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
