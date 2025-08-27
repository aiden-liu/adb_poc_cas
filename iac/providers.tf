terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.87.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

provider "databricks" {
  # Configuration options
  host = local.databricks_workspace_host
}