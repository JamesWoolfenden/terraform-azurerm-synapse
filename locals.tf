locals {
  # node_count and auto_scale are mutually exclusive
  spark_pool_node_count = try(var.spark_pool.auto_scale, null) == null ? try(var.spark_pool.node_count, null) : null
}
