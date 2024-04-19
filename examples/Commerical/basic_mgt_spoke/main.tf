# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_vnet_spoke" {
  #source  = "azurenoops/overlays-management-spoke/azurerm"
  #version = "~> x.x.x"
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

  # (Required) Collect Hub Virtual Network Parameters
  # Hub network details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # pick the value for log analytics resource if which created by hub module
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.hub-logws.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.hub-logws.workspace_id

  # DNS Resource Group
  existing_private_dns_zone_blob_id = data.azurerm_private_dns_zone.blob.id

  # (Required) To enable Azure Monitoring and flow logs
  # To enable traffic analytics, set `enable_traffic_analytics = true` in the module.
  enable_traffic_analytics = var.enable_traffic_analytics

  # (Required) Provide valid VNet Address space for spoke virtual network.
  virtual_network_address_space = var.id_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.id_subnets

  # (Optional) By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table,
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_id_route_table

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # (Optional) Tags
  add_tags = local.tags # Tags to be applied to all resources
}

# Create VNet Peering between Hub and Identity VNets
module "mod_hub_to_id_vnet_peering" {
  source  = "azurenoops/overlays-vnet-peering/azurerm"
  version = "0.1.6-beta"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.id_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_vnet_spoke.resource_group_name
  different_subscription_dest_resource_group_name = data.azurerm_virtual_network.hub-vnet.resource_group_name

  alias_subscription_id                 = data.azurerm_client_config.current.subscription_id
  vnet_src_name                         = module.mod_vnet_spoke.virtual_network_name
  vnet_src_id                           = module.mod_vnet_spoke.virtual_network_id
  different_subscription_dest_vnet_name = data.azurerm_virtual_network.hub-vnet.name
  different_subscription_dest_vnet_id   = data.azurerm_virtual_network.hub-vnet.id
}
