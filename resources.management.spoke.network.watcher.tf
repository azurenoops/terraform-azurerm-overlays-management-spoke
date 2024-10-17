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
resource "azurerm_network_watcher_flow_log" "nwflog" {
  for_each                  = var.spoke_subnets
  name                      = lower(format("network-watcher-flow-log-%s-%s", var.org_name, each.value.name))
  network_watcher_name      = data.azurerm_network_watcher.nwatcher.name
  resource_group_name       = data.azurerm_resource_group.netwatch.name # Must provide Netwatcher resource Group
  network_security_group_id = module.nsg[each.key].resource_id
  storage_account_id        = module.spoke_st.resource_id
  enabled                   = true
  version                   = 2
  retention_policy {
    enabled = true
    days    = 0
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = var.existing_log_analytics_workspace_id
    workspace_region      = local.location
    workspace_resource_id = var.existing_log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}

