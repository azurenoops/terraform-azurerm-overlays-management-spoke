# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account Creation
#----------------------------------------------------------
module "mgt_spoke" {
  depends_on = [ module.mod_scaffold_rg ]
  source                       = "azurenoops/overlays-storage-account/azurerm"
  version                      = ">= 0.1.0"
  existing_resource_group_name = local.resource_group_name
  storage_account_custom_name  = local.spoke_sa_name
  location                     = local.location
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  workload_name                = var.workload_name
  org_name                     = var.org_name
  account_kind                 = var.spoke_storage_account_kind
  account_tier                 = var.spoke_storage_account_tier
  account_replication_type     = var.spoke_storage_account_replication_type
  enable_resource_locks        = var.enable_resource_locks

  add_tags = merge({ "ResourceName" = format("spokestdiaglogs%s", lower(replace(local.spoke_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}
