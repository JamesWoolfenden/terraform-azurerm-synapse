# holden:ignore:HLD_TF_063_MEDIUM auto_scale, library_requirement and spark_config are optional nested blocks, so each must be a dynamic block driven by var.spark_pool; there is no simpler static form
resource "azurerm_synapse_spark_pool" "this" {
  count                               = var.spark_pool == null ? 0 : 1
  name                                = var.spark_pool.name
  synapse_workspace_id                = azurerm_synapse_workspace.this.id
  node_size_family                    = var.spark_pool.node_size_family
  node_size                           = var.spark_pool.node_size
  spark_version                       = var.spark_pool.spark_version
  node_count                          = local.spark_pool_node_count
  cache_size                          = var.spark_pool.cache_size
  compute_isolation_enabled           = var.spark_pool.compute_isolation_enabled
  dynamic_executor_allocation_enabled = var.spark_pool.dynamic_executor_allocation_enabled
  min_executors                       = var.spark_pool.min_executors
  max_executors                       = var.spark_pool.max_executors
  session_level_packages_enabled      = var.spark_pool.session_level_packages_enabled
  spark_log_folder                    = var.spark_pool.spark_log_folder
  spark_events_folder                 = var.spark_pool.spark_events_folder

  auto_pause {
    delay_in_minutes = var.spark_pool.auto_pause_delay_in_minutes
  }

  dynamic "auto_scale" {
    for_each = var.spark_pool.auto_scale[*]
    content {
      min_node_count = auto_scale.value.min_node_count
      max_node_count = auto_scale.value.max_node_count
    }
  }

  dynamic "library_requirement" {
    for_each = var.spark_pool.library_requirement[*]
    content {
      content  = library_requirement.value.content
      filename = library_requirement.value.filename
    }
  }

  dynamic "spark_config" {
    for_each = var.spark_pool.spark_config[*]
    content {
      content  = spark_config.value.content
      filename = spark_config.value.filename
    }
  }

  tags = var.common_tags
}
