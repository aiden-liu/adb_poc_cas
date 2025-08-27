data "azurerm_storage_account" "warehouse" {
  name                = var.warehouse_storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_container" "this" {
  for_each           = local.filepath_container_domain_source_mapping
  name               = each.key
  storage_account_id = data.azurerm_storage_account.warehouse.id
}

resource "azurerm_storage_data_lake_gen2_path" "this" {
  for_each = {
    for p in local.paths : "${p.container}_${p.domain}_${p.source}" => p
  }

  storage_account_id = data.azurerm_storage_account.warehouse.id
  filesystem_name    = data.azurerm_storage_container.this[each.value.container].name
  path               = "${each.value.domain}/${each.value.source}/__partitions" # datalake gen2 path must not have leading or tailing slashes or double slashes
  resource           = "directory"
}

## Configure new schema in Databricks

resource "databricks_schema" "main" {
  for_each = {
    for p in local.catalog_paths : "${p.tier}_${p.domain}_${p.source}" => p
  }

  name         = replace(format("%s_%s", each.value.domain, each.value.source), "-", "_")
  catalog_name = format("%s_%s", var.environment, each.value.tier)
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/%s/%s/", each.value.tier, var.warehouse_storage_account_name, each.value.domain, each.value.source)
  comment      = "Managed by Terraform"
  properties = {
    structure = "domain_source"
  }
}

resource "databricks_volume" "main" {
  for_each = {
    for p in local.volume_mount_paths : "${p.container}_${p.domain}_${p.source}" => p
  }

  name             = replace(format("vol_%s_%s", each.value.container, each.value.source), "-", "_")
  catalog_name     = format("%s_%s", var.environment, "bronze")
  schema_name      = replace(format("%s_%s", each.value.domain, each.value.source), "-", "_")
  volume_type      = "EXTERNAL"
  storage_location = each.value.path
  comment          = "Managed by Terraform"

  depends_on = [databricks_schema.main]
}