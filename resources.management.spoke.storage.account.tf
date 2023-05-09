# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
module "overlays-storage-account" {
  source                   = "azurenoops/overlays-storage-account/azurerm"
  version                  = ">= 0.1.0"
  resource_group_name      = local.resource_group_name
  storage_account_custom_name = local.spoke_sa_name
  location                 = local.location
  environment              = var.environment
  deploy_environment       = var.deploy_environment
  workload_name            = var.workload_name
  org_name                 = var.org_name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_resource_locks    = var.enable_resource_locks
  add_tags                 = merge({ "ResourceName" = format("spokestdiaglogs%s", lower(replace(local.spoke_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
