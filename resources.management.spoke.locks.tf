# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Vnet Lock configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_management_lock" "vnet_resource_group_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.spoke_vnet_name}-${var.lock_level}-lock"
  scope      = azurerm_virtual_network.spoke_vnet.id
  lock_level = var.lock_level
  notes      = "Virtual Network '${local.spoke_vnet_name}' is locked with '${var.lock_level}' level."
}



