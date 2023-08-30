# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"         # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"          # dev | test | prod
environment        = "usgovernment" # public | usgovernment

# The default region to deploy to
default_location = "usgovvirginia"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

#################################################
# Identity Management Spoke Virtual Network   ###
#################################################

# Enable Identity Management Spoke Virtual Network
# If you do not want to create Identity Management Spoke Virtual Network,
# remove this section from the configuration file.

# Identity Virtual Network Parameters
id_name               = "id"
id_vnet_address_space = ["10.8.9.0/24"]
id_subnets = {
  default = {
    name                                       = "id"
    address_prefixes                           = ["10.8.9.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.6.0/24", "10.8.7.0/24", "10.8.8.0/24"], ["10.8.6.0/24"]],
    ]
  }
}

# Private DNS Zones
# Add in the list of private_dns_zones to be created.
id_private_dns_zones = []

# Enable forced tunneling on the route table
enable_forced_tunneling_on_id_route_table = true


