locals {
  filepath_container_domain_source_mapping = merge(
    var.filepath_tier_domain_source_mapping,
    var.filepath_volume_mount
  )
  paths = flatten([
    for container, domains in local.filepath_container_domain_source_mapping : [
      for domain, sources in domains : [
        for source in sources : {
          container = container
          domain    = domain
          source    = source
          path      = "${container}/${domain}/${source}"
        }
      ]
    ]
  ])
  catalog_paths = flatten([
    for tier, domains in var.filepath_tier_domain_source_mapping : [
      for domain, sources in domains : [
        for source in sources : {
          tier   = tier
          domain = domain
          source = source
          path   = "${tier}/${domain}/${source}"
        }
      ]
    ]
  ])
  volume_mount_paths = flatten([
    for container, domains in var.filepath_volume_mount : [
      for domain, sources in domains : [
        for source in sources : {
          container = container
          domain    = domain
          source    = source
          path      = "abfss://${container}@${var.warehouse_storage_account_name}.dfs.core.windows.net/${domain}/${source}"
        }
      ]
    ]
  ])
  databricks_workspace_host = data.azurerm_databricks_workspace.this.workspace_url
}