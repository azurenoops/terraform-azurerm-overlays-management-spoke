# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# SRC PEER CONF
###############

variable "allow_source_virtual_spoke_network_access" {
  description = "Option allow_virtual_network_access for the spoke vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}

variable "allow_source_forwarded_spoke_traffic" {
  description = "Option allow_forwarded_traffic for the spoke vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = true
}

variable "allow_source_gateway_spoke_transit" {
  description = "Option allow_gateway_transit for the spoke vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "use_source_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}

################
# DEST PEER CONF
################

variable "allow_dest_virtual_hub_network_access" {
  description = "Option allow_virtual_network_access for the hub vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}

variable "allow_dest_forwarded_hub_traffic" {
  description = "Option allow_forwarded_traffic for the hub vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = true
}

variable "allow_dest_gateway_hub_transit" {
  description = "Option allow_gateway_transit for the hub vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = true
}

variable "use_dest_remote_hub_gateway" {
  description = "Option use_remote_gateway for the hub vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}