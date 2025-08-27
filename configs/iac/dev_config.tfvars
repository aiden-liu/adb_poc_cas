resource_group_name            = "rg-dataops-warehouse"
warehouse_storage_account_name = "stwarehousetis"
filepath_tier_domain_source_mapping = {
  bronze = {
    transport = ["cas"]
  }
  silver = {
    transport = ["cas"]
  }
  gold = {
    transport = ["cas"]
  }
}

filepath_volume_mount = {
  landing = {
    transport = ["cas"]
  }
}
databricks_workspace_name = "dbw-warehouse-tis"
environment               = "dev"