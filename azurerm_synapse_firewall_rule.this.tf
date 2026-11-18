resource "azurerm_synapse_firewall_rule" "this" {
  for_each             = var.firewall_rules
  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  start_ip_address     = each.value.start_ip_address
  end_ip_address       = each.value.end_ip_address
}
