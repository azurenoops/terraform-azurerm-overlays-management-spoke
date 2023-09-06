# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_vnet_spoke" {
  #source  = "azurenoops/overlays-management-spoke/azurerm"
  #version = "~> 2.0"
  source = "../../.."

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.id_name

  # Collect Spoke Virtual Network Parameters
  # Spoke network details to create peering and other setup
  hub_virtual_network_name        = data.azurerm_virtual_network.hub-vnet.name
  hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address
  hub_resource_group_name         = data.azurerm_virtual_network.hub-vnet.resource_group_name

  # To enable traffic analytics, set `enable_traffic_analytics = true` in the module.
  enable_traffic_analytics = var.enable_traffic_analytics

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Hub module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = data.azurerm_log_analytics_workspace.hub-logws.id
  log_analytics_customer_id            = data.azurerm_log_analytics_workspace.hub-logws.workspace_id
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.id_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  spoke_subnets = var.id_subnets

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_id_route_table

  # Private DNS Zone Settings
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.id_private_dns_zones

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.tags # Tags to be applied to all resources
}
