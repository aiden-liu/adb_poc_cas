variable "azure_datalake_file_path_prefix" {
  type        = string
  description = "Prefix for the file path in the Azure Data Lake Gen2."
  default     = ""
}

variable "warehouse_storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account to be used as a data warehouse."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the storage account is located."
}

variable "filepath_tier_domain_source_mapping" {
  description = "Values of the domain and source name for each tier"
  type        = map(map(list(string)))
}

variable "filepath_volume_mount" {
  description = "The volume mount path for the databricks workspace, all volumes are mounted under bronze."
  type        = map(map(list(string)))
}

variable "databricks_workspace_name" {
  description = "Databricks workspace name"
  type        = string
}

variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, prod)."
  type        = string
}