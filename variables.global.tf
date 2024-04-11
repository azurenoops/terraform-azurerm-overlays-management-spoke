# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environment"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}

variable "disable_telemetry" {
  description = "If set to true, will disable the telemetry sent as part of the module."
  type        = string
  default     = false
}

variable "subscription_id_hub" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Hub\" for resource deployment and correct placement in the Management Group hierarchy."
  sensitive   = true
  default     = null
}

#######################
# RG Configuration   ##
#######################

variable "create_spoke_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

############################
# Hub DNS Configuration   ##
############################

variable "private_dns_zone_hub_resource_group_name" {
  description = "The name of the private DNS zone resource group"
  type        = string
  default     = null
}

########################
# Hub Configuration   ##
########################

variable "existing_hub_resource_group_name" {
  description = "The name of the hub resource group"
  default     = null
}

variable "existing_hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  default     = null
}

variable "existing_hub_firewall_name" {
  description = "The name of the hub firewall"
  default     = null
}

variable "existing_log_analytics_workspace_name" {
  description = "Specifies the name of the Log Analytics Workspace resource"
  default     = null
}

variable "existing_log_analytics_workspace_resource_name" {
  description = "Specifies the name of the Log Analytics Workspace resource group"
  default     = null
}

variable "use_remote_gateways" {
  description = "Controls if remote gateways can be used on the local virtual network."
  type        = bool
  default     = false
}
