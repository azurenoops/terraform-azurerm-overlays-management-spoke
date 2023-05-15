# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Network Watcher and Flog Logs for Managment Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment              
              * Network Watcher         
AUTHOR/S: jspinella
*/

#-------------------------------------
# Network Watcher - Default is "true"
#-------------------------------------
resource "azurerm_resource_group" "nwatcher" {
  count    = var.is_spoke_deployed_to_same_hub_subscription == false ? 1 : 0
  name     = "NetworkWatcherRG"
  location = local.location
  tags     = merge({ "ResourceName" = "NetworkWatcherRG" }, local.default_tags, var.add_tags, )
}

resource "azurerm_network_watcher" "nwatcher" {
  count               = var.is_spoke_deployed_to_same_hub_subscription == false ? 1 : 0
  name                = "NetworkWatcher_${var.location}"
  location            = local.location
  resource_group_name = azurerm_resource_group.nwatcher.0.name
  tags                = merge({ "ResourceName" = format("%s", "NetworkWatcher_${var.location}") }, local.default_tags, var.add_tags, )
}

#-----------------------------------------
# Network flow logs for subnet and NSG
#-----------------------------------------
resource "azurerm_network_watcher_flow_log" "nwflog" {
  for_each                  = var.spoke_subnets
  name                      = lower("Network-Watcher-flog-log-${each.value.name}")
  network_watcher_name      = var.is_spoke_deployed_to_same_hub_subscription == true ? "NetworkWatcher_${local.netwatcher_rg_location}" : azurerm_network_watcher.nwatcher.0.name
  resource_group_name       = local.netwatcher_rg_name # Must provide Netwatcher resource Group
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = module.mgt_spoke.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 0
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = var.log_analytics_customer_id
    workspace_region      = local.location
    workspace_resource_id = var.log_analytics_workspace_id
    interval_in_minutes   = 10
  }
}

