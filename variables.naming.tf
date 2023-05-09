# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Generic naming Configuration    ##
####################################
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_resource_group_name" {
  description = "The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_storage_account_name" {
  description = "The name of the custom storage account to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_virtual_network_name" {
  description = "The name of the custom virtual network to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_subnet_name" {
  description = "The name of the custom subnet to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_network_security_group_name" {
  description = "The name of the custom network security group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "custom_route_table_name" {
  description = "The name of the custom route table to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}
