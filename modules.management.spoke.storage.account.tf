# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Hub Logging Storage Account for Log Archiving
#----------------------------------------------------------
module "spoke_st" {
  depends_on                    = [module.mod_scaffold_rg]
  source                        = "azure/avm-res-storage-storageaccount/azurerm"
  version                       = "0.1.2"
  resource_group_name           = local.resource_group_name
  name                          = local.spoke_sa_name
  location                      = local.location
  account_kind                  = var.spoke_storage_account_kind
  account_tier                  = var.spoke_storage_account_tier
  account_replication_type      = var.spoke_storage_account_replication_type
  public_network_access_enabled = true

  # Network Rules
  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = var.spoke_storage_bypass_ip_cidr
    virtual_network_subnet_ids = toset([azurerm_subnet.default_snet["default"].id])
  }

  # Private Endpoint
  private_endpoints = {
    "blob" = {
      subnet_resource_id            = azurerm_subnet.default_snet["default"].id
      subresource_name              = ["blob"]
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.spoke_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # Customer Managed Key
  customer_managed_key = var.enable_customer_managed_key ? {
    key_vault_resource_id              = var.key_vault_resource_id
    key_name                           = var.key_name
    user_assigned_identity_resource_id = var.user_assigned_identity_id
  } : null

  # Blob Properties
  blob_properties = {
    container_delete_retention_policy = {
      days = 30
    }
    delete_retention_policy = {
      days = 30
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("spokestdiaglogs%s", lower(replace(local.spoke_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}

data "azurerm_monitor_diagnostic_categories" "main" {
  resource_id = module.spoke_st.id
}

