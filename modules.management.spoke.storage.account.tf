# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# spoke Logging Storage Account for Log Archiving
#----------------------------------------------------------
module "spoke_st" {
  depends_on                    = [module.mod_scaffold_rg]
  source                        = "azure/avm-res-storage-storageaccount/azurerm"
  version                       = "0.2.7"
  // Globals
  resource_group_name = local.resource_group_name
  name                = local.spoke_sa_name
  location            = local.location

  // Account 
  account_kind              = var.spoke_storage_account_kind
  account_tier              = var.spoke_storage_account_tier
  account_replication_type  = var.spoke_storage_account_replication_type
  shared_access_key_enabled = true

  // Marked as true for PE
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
      subresource_name              = "blob"
      private_dns_zone_resource_ids = var.existing_private_dns_zone_blob_id
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = "${local.spoke_vnet_name}-${var.lock_level}-lock"
    kind = var.lock_level
  } : null

  # Managed Idenities
  managed_identities = var.enable_customer_managed_keys ? {
    system_assigned            = true
    user_assigned_resource_ids = [azurerm_user_assigned_identity.user_assigned_identity[0].id]
  } : {
      system_assigned            = true
      user_assigned_resource_ids = length(var.spoke_storage_user_assigned_resource_ids) > 0 ? var.spoke_storage_user_assigned_resource_ids : []
  }

  # Customer Managed Key
  customer_managed_key = var.enable_customer_managed_keys ? {
    key_vault_resource_id  = var.key_vault_resource_id
    key_name               = var.key_name
    user_assigned_identity = { resource_id = azurerm_user_assigned_identity.user_assigned_identity[0].id }
  } : null

  # Role Assignments
  role_assignments = {
    role_assignment_uai = {
      role_definition_id_or_name       = "Storage Blob Data Contributor"
      principal_id                     = coalesce(azurerm_user_assigned_identity.user_assigned_identity[0].principal_id, data.azurerm_client_config.current.object_id)
      skip_service_principal_aad_check = false
    },
    role_assignment_current_user = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
  }

  # Blob Properties
  containers = var.spoke_storage_containers

  # Blob Properties
  blob_properties = {
    container_delete_retention_policy = {
      days = 30
    }
    delete_retention_policy = {
      days = 30
    }
  }

  // Storage Diagnostic Settings
  diagnostic_settings_blob = {
    sendToLogAnalytics = {
      name                           = "sendToLogAnalytics_storage"
      workspace_resource_id          = var.existing_log_analytics_workspace_resource_id
      log_analytics_destination_type = "Dedicated" 
    }
  }

  # telemtry
  enable_telemetry = var.disable_telemetry

  # Tags
  tags = merge({ "ResourceName" = format("spokestdiaglogs%s", lower(replace(local.spoke_sa_name, "/[[:^alnum:]]/", ""))) }, local.default_tags, var.add_tags, )
}

# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  count               = var.enable_customer_managed_keys ? 1 : 0
  location            = local.location
  resource_group_name = local.resource_group_name
  name                = "${local.spoke_sa_name}-usi"
}

resource "azurerm_key_vault_access_policy" "spoke_storage" {
  key_vault_id = var.key_vault_resource_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.user_assigned_identity.principal_id

  secret_permissions = ["Get"]
  key_permissions = [
    "Get",
    "UnwrapKey",
    "WrapKey"
  ]
}

data "azurerm_monitor_diagnostic_categories" "main" {
  resource_id = module.spoke_st.resource.id
}

