# Azurerm provider configuration
provider "azurerm" {
  features {}
}

module "mod_vnet_ops_spoke" {
  #source  = "azurenoops/overlays-management-spoke/azurerm"
  #version = ">= 2.0.0"
  source = "../.."

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "ops-core"

  # Collect Spoke Virtual Network Parameters
  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = data.azurerm_virtual_network.hub-vnet.id
  hub_firewall_private_ip_address = "10.8.4.68"
  hub_storage_account_id          = data.azurerm_storage_account.hub-st.id

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = data.azurerm_log_analytics_workspace.hub-logws.id
  log_analytics_customer_id            = data.azurerm_log_analytics_workspace.hub-logws.workspace_id
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = ["10.8.7.0/24"] # (Required)  Spoke Virtual Network Parameters

  # (Required) Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = true

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  spoke_subnets = {
    default = {
      name                                       = "ops-core"
      address_prefixes                           = ["10.8.7.0/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
      nsg_subnet_inbound_rules = [
        # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
        # Use "" for description to use default description
        # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
        ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.8.0/24"], [""]],
      ]
    }
  }

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = true

  # Private DNS Zone Settings
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = ["privatelink.table.core.windows.net"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {
    Example = "Management Operations Core Spoke"
  } # Tags to be applied to all resources
}

module "mod_vnet_svcs_spoke" {
  #source  = "azurenoops/overlays-management-spoke/azurerm"
  #version = ">= 2.0.0"
  source = "../.."

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "svcs-core"

  # Collect Spoke Virtual Network Parameters
  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = data.azurerm_virtual_network.hub-vnet.id
  hub_firewall_private_ip_address = "10.8.4.68"
  hub_storage_account_id          = data.azurerm_storage_account.hub-st.id

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = data.azurerm_log_analytics_workspace.hub-logws.id
  log_analytics_customer_id            = data.azurerm_log_analytics_workspace.hub-logws.workspace_id
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = ["10.8.8.0/24"] # (Required)  Spoke Virtual Network Parameters

  # (Required) Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = true

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  spoke_subnets = {
    default = {
      name                                       = "svcs-core"
      address_prefixes                           = ["10.8.8.0/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
      nsg_subnet_inbound_rules = [
        # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
        # Use "" for description to use default description
        # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
        ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.7.0/24"], [""]],
      ]
    }
  }

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = true

  # Private DNS Zone Settings
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = ["privatelink.table.core.windows.net"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {
    Example = "Management Shared Services Core Spoke"
  } # Tags to be applied to all resources
}

