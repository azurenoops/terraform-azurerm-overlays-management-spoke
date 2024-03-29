# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Terraform Module to deploy the Network Watcher and Flog Logs for Management Spoke Network based on the Azure Mission Landing Zone conceptual architecture
DESCRIPTION: The following components will be options in this deployment              
              * Network Watcher         
AUTHOR/S: jrspinella
*/

#-------------------------------------
# Network Watcher 
#-------------------------------------
data "azurerm_network_watcher" "nwatcher" {
  depends_on          = [azurerm_virtual_network.spoke_vnet]
  name                = "NetworkWatcher_${local.location}"
  resource_group_name = data.azurerm_resource_group.netwatch.name
}

#-----------------------------------------
# Network flow logs for subnet and NSG
#-----------------------------------------
resource "azurerm_network_watcher_flow_log" "nwflog" {
  for_each                  = var.spoke_subnets
  name                      = lower("Network-Watcher-flog-log-${each.value.name}")
  network_watcher_name      = data.azurerm_network_watcher.nwatcher.name
  resource_group_name       = "NetworkWatcherRG" # Must provide Netwatcher resource Group
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = module.mgt_storage_account_spoke.storage_account_id
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

