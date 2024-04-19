# Azure Virtual Network Management Spoke Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-management-spoke/azurerm/)

This Overlay terraform module deploys a Management Spoke network using the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) to be used in a [SCCA compliant Management Network](https://registry.terraform.io/modules/azurenoops/overlays-management-spoke/azurerm/latest).

Usually, only one hub in each region with multiple spokes and each of them can also be in separate subscriptions.

This is designed to quickly deploy hub and spoke architecture in Azure and further security hardening would be recommend to add appropriate NSG rules to use this for any production workloads.

## Using Azure Clouds

Since this module is built for both public and us government clouds. The `environment` variable defaults to `public` for Azure Cloud. When using this module with the Azure Government Cloud, you must set the `environment` variable to `usgovernment`.

You will also need to set the azurerm provider `environment` variable to the proper cloud as well. This will ensure that the correct Azure Government Cloud endpoints are used. You will also need to set the `location` variable to a valid Azure Government Cloud location.

Example Usage for Azure Government Cloud:

```hcl

provider "azurerm" {
  environment = "usgovernment"
}

module "overlays-management-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "2.0.0"

  location = "usgovvirginia"
  environment = "usgovernment"
  ...
}

```

### Resource Provider List

Terraform requires the following resource providers to be available:

- Microsoft.Network
- Microsoft.Storage
- Microsoft.Compute
- Microsoft.KeyVault
- Microsoft.Authorization
- Microsoft.Resources
- Microsoft.OperationalInsights
- Microsoft.GuestConfiguration
- Microsoft.Insights
- Microsoft.Advisor
- Microsoft.Security
- Microsoft.OperationsManagement
- Microsoft.AAD
- Microsoft.AlertsManagement
- Microsoft.Authorization
- Microsoft.AnalysisServices
- Microsoft.Automation
- Microsoft.Subscription
- Microsoft.Support
- Microsoft.PolicyInsights
- Microsoft.SecurityInsights
- Microsoft.Security
- Microsoft.Monitor
- Microsoft.Management
- Microsoft.ManagedServices
- Microsoft.ManagedIdentity
- Microsoft.Billing
- Microsoft.Consumption

Please note that some of the resource providers may not  be available in Azure Government Cloud. Please check the [Azure Government Cloud documentation](https://docs.microsoft.com/en-us/azure/azure-government/documentation-government-get-started-connect-with-cli) for more information.

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Management Spoke Architecture

The following reference architecture shows how to implement a SCCA compliant hub-spoke topology in Azure. The Management spoke virtual networks connect with the hub and can be used to isolate management workloads. Management Spokes can exist in different subscriptions and represent different environments, such as Production and Non-production.

![Architecture](https://github.com/azurenoops/terraform-azurerm-overlays-management-spoke/blob/main/docs/images/mission_enclave_spoke_simple.png)

These types of resources are supported:

- [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
- [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
- [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
- [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)
- [Private Link service/Endpoint network policies on Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#enforce_private_link_endpoint_network_policies)
- [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
- [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
- [Routing traffic to Hub firewall](https://www.terraform.io/docs/providers/azurerm/r/route_table.html)
- [Azure Monitoring Diagnostics](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
- [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
- [Network Watcher Workflow Logs](https://www.terraform.io/docs/providers/azurerm/r/network_watcher_flow_log.html)

## Module Usage

```hcl
# Azurerm provider configuration
provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "hub-vnet" {
  name                = "anoa-eus-hub-core-dev-vnet"
  resource_group_name = "anoa-eus-hub-core-dev-rg"
}

data "azurerm_storage_account" "hub-st" {
  name                = "anoaeusd46f0d7ae4devst"
  resource_group_name = "anoa-eus-hub-core-dev-rg"
}

data "azurerm_log_analytics_workspace" "hub-logws" {
  name                = "anoa-eus-ops-mgt-logging-dev-log"
  resource_group_name = "anoa-eus-ops-mgt-logging-dev-rg"
}

module "vnet-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "2.0.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name,
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = "eastus"
  deploy_environment    = "dev"
  org_name              = "anoa"
  environment           = "public"
  workload_name         = "id-core"

  # (Required) Collect Hub Virtual Network Parameters
  # Hub network details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # pick the value for log analytics resource if which created by hub module
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.hub-logws.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.hub-logws.workspace_id

  # Blob Private DNS Id for Storage Account
  existing_private_dns_zone_blob_id = data.azurerm_resource_group.dns.id

  # (Required) To enable Azure Monitoring and flow logs
  # To enable traffic analytics, set `enable_traffic_analytics = true` in the module.
  enable_traffic_analytics = var.enable_traffic_analytics

  # Provide valid VNet Address space for spoke virtual network.
  virtual_network_address_space = ["10.0.100.0/24"] # (Required)  Hub Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = {
    default = {
      name                                       = "id-core"
      address_prefixes                           = ["10.0.100.64/26"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
    }
  }

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table,
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = true

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = {
    Example = "Management Identity Core Spoke"
  } # Tags to be applied to all resources
}
```

## Spoke Networking

Spoke Networking is set up in a Management Spoke Overlay design based on the SCCA Hub/Spoke architecture. The Management Spoke Overlay is a central point of connectivity to many different networks.

The following parameters affect Management Spoke Overlay Networking.
vnet-spoke
Parameter name | Location | Default Value | Description
-------------- | ------------- | ------------- | -----------
`virtual_network_address_space` | `variables.vnet.tf` | '10.0.100.0/24' | The CIDR Virtual Network Address Prefix for the Spoke Virtual Network.

## Subnets

This module handles the creation and a list of address spaces for subnets. This module uses `for_each` to create subnets and corresponding service endpoints, service delegation, and network security groups. This module associates the subnets to network security groups as well with additional user-defined NSG rules.

This module creates 1 subnets by default: Default Subnet

## Virtual Network service endpoints

Service Endpoints allows connecting certain platform services into virtual networks.  With this option, Azure virtual machines can interact with Azure SQL and Azure Storage accounts, as if they’re part of the same virtual network, rather than Azure virtual machines accessing them over the public endpoint.

This module supports enabling the service endpoint of your choosing under the virtual network and with the specified subnet. The list of Service endpoints to associate with the subnet values include:

`Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    default = {
      subnet_name           = "default"
      subnet_address_prefix = "10.1.2.0/24"

      service_endpoints     = ["Microsoft.Storage"]
    }
  }

# ....omitted

}
```

## Subnet Service Delegation

Subnet delegation enables you to designate a specific subnet for an Azure PaaS service of your choice that needs to be injected into your virtual network. The Subnet delegation provides full control to manage the integration of Azure services into virtual networks.

This module supports enabling the service delegation of your choosing under the virtual network and with the specified subnet.  For more information, check the [terraform resource documentation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_delegation).

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    default = {
      subnet_name           = "default"
      subnet_address_prefix = "10.1.2.0/24"

      delegation = {
        name = "demodelegationcg"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }

# ....omitted

}
```

## `private_endpoint_network_policies_enabled` - Private Link Endpoint on the subnet

Network policies, like network security groups (NSG), are not supported for Private Link Endpoints. In order to deploy a Private Link Endpoint on a given subnet, you must set the `private_endpoint_network_policies_enabled` attribute to `true`.

This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link endpoint on the subnet. The default value is `false`. If you are enabling the Private Link Endpoints on the subnet you shouldn't use Private Link Services as it's conflicts.

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
   default = {
      subnet_name           = "default"
      subnet_address_prefix = "10.1.2.0/24"
      private_endpoint_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

  }
```

## `private_link_service_network_policies_enabled` - private link service on the subnet

In order to deploy a Private Link Service on a given subnet, you must set the `private_link_service_network_policies_enabled` attribute to `true`. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link service on the subnet. The default value is `false`. If you are enabling the Private Link service on the subnet then, you shouldn't use Private Link endpoints as it's conflicts.

```hcl
module "vnet-spoke" {
  source  = "azurenoops/overlays-management-spoke/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    default = {
      subnet_name           = "default"
      subnet_address_prefix = "10.1.2.0/24"
      private_link_service_network_policies_enabled = true

        }
      }
    }
  }

# ....omitted

}
```

## Network Security Groups

By default, the network security groups connected to subnets will only allow necessary traffic and block everything else (deny-all rule). Use `nsg_subnet_rules` in this Terraform module to create a Network Security Group (NSG) for each subnet and allow it to add additional rules for inbound flows.

In the Source and Destination columns, `VirtualNetwork`, `AzureLoadBalancer`, and `Internet` are service tags, rather than IP addresses. In the protocol column, Any encompasses `TCP`, `UDP`, and `ICMP`. When creating a rule, you can specify `TCP`, `UDP`, `ICMP` or `*`. `0.0.0.0/0` in the Source and Destination columns represents all addresses.

*You cannot remove the default rules, but you can override them by creating rules with higher priorities.*

This module supports enabling the NSG Rules of your choosing under the virtual network and with the specified subnet.  For more information, check the [terraform resource documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#security_rule).

```hcl
module "vnet-hub" {
  source  = "azurenoops/overlays-management-hub/azurerm"
  version = "x.x.x"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints
  subnets = {
    mgnt_subnet = {
      subnet_name           = "management"
      subnet_address_prefix = "10.1.2.0/24"

      nsg_subnet_rules = [
          {
            name                       = "allow-443",
            description                = "Allow access to port 443",
            priority                   = 100,
            direction                  = "Inbound",
            access                     = "Allow",
            protocol                   = "*",
            source_port_range          = "*",
            destination_port_range     = "443",
            source_address_prefix      = "*",
            destination_address_prefix = "*"
          }
        ]
      }
    }
  }

# ....omitted

}
```

## Peering to Hub

To peer spoke networks to the hub networks requires the service principal that performs the peering has `Network Contributor` role on hub network. Linking the Spoke to Hub DNS zones, the service principal also needs the `Private DNS Zone Contributor` role on hub network.

If Log Analytics workspace is created in hub or another subscription then, the service principal must have `Log Analytics Contributor` role on workspace or a custom role to connect resources to workspace.

## Optional Features

Management Spoke Overlay has optional features that can be enabled by setting parameters on the deployment.

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Azure Network DDoS Protection Plan

By default, this module will not create a DDoS Protection Plan. You can enable/disable it by appending an argument `create_ddos_plan`. If you want to enable a DDoS plan using this module, set argument `create_ddos_plan = true`

## Azure Network Network Watcher

This module handle the provision of Network Watcher resource by defining `create_network_watcher` variable. It will enable network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. Since Azure uses a specific naming standard on network watchers, It will create a resource group `NetworkWatcherRG` and adds the location specific resource.

> **Note:*-*Log Analytics workspace is required for NSG Flow Logs and Traffic Analytics. If you want to enable NSG Flow Logs and Traffic Analytics, you must create a Log Analytics workspace and provide the workspace name set argument `log_analytics_workspace_name` and rg set argument `log_analytics_workspace_resource_group_name`*

## Enable Force Tunneling for the Firewall

By default, this module will not create a force tunnel on the firewall. You can enable/disable it by appending an argument `enable_force_tunneling` located in `variables.fw.tf` If you want to enable a DDoS plan using this module, set argument `enable_force_tunneling = true`. Enabling this feature will ensure that the firewall is the default route for all the T0 through T3 Network routes.

## Custom DNS servers

This is an optional feature and only applicable if you are using your own DNS servers superseding default DNS services provided by Azure.Set the argument `dns_servers = ["4.4.4.4"]` to enable this option. For multiple DNS servers, set the argument `dns_servers = ["4.4.4.4", "8.8.8.8"]`

## Recommended naming and tagging conventions

Applying tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair.

For example, you can apply the name `Environment` and the value `Production` to all the resources in production.
For recommendations on how to implement a tagging strategy, see Resource naming and tagging decision guide.

>**Important*-:
Tag names are case-insensitive for operations. A tag with a tag name, regardless of the casing, is updated or retrieved. However, the resource provider might keep the casing you provide for the tag name. You'll see that casing in cost reports. **Tag values are case-sensitive.**

An effective naming convention assembles resource names by using important resource information as parts of a resource's name.

For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.

## Other resources

-[Hub-spoke network topology in Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
-[Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
