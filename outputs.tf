output "sql_pool" {
  description = "The dedicated SQL pool (null when not created)"
  value       = one(azurerm_synapse_sql_pool.this)
}

output "spark_pool" {
  description = "The Apache Spark pool (null when not created)"
  value       = one(azurerm_synapse_spark_pool.this)
}

output "firewall_rules" {
  description = "The workspace firewall rules"
  value       = azurerm_synapse_firewall_rule.this
}

output "workspace_security_alert_policy" {
  description = "The workspace security alert policy"
  value       = one(azurerm_synapse_workspace_security_alert_policy.this)
  sensitive   = true
}

output "workspace_extended_auditing_policy" {
  description = "The workspace extended auditing policy"
  value       = one(azurerm_synapse_workspace_extended_auditing_policy.this)
  sensitive   = true
}

output "workspace_vulnerability_assessment" {
  description = "The workspace vulnerability assessment"
  value       = one(azurerm_synapse_workspace_vulnerability_assessment.this)
  sensitive   = true
}

output "sql_pool_security_alert_policy" {
  description = "The SQL pool security alert policy"
  value       = one(azurerm_synapse_sql_pool_security_alert_policy.this)
  sensitive   = true
}

output "sql_pool_extended_auditing_policy" {
  description = "The SQL pool extended auditing policy"
  value       = one(azurerm_synapse_sql_pool_extended_auditing_policy.this)
  sensitive   = true
}

output "sql_pool_vulnerability_assessment" {
  description = "The SQL pool vulnerability assessment"
  value       = one(azurerm_synapse_sql_pool_vulnerability_assessment.this)
  sensitive   = true
}

output "sql_pool_vulnerability_assessment_baselines" {
  description = "The SQL pool vulnerability assessment baselines"
  value       = azurerm_synapse_sql_pool_vulnerability_assessment_baseline.this
  sensitive   = true
}
