# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "spoke_storage_account_kind" {
  description = "The Kind of storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage. Default is StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "spoke_storage_account_tier" {
  description = "The Tier of storage account to create. Valid options are Standard and Premium. Default is Standard."
  type        = string
  default     = "Standard"
}

variable "spoke_storage_account_replication_type" {
  description = "The Replication Type of storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. Default is LRS."
  type        = string
  default     = "GRS"
}

variable "spoke_storage_bypass_ip_cidr" {
  description = "List of IP CIDRs that are allowed to bypass the network rules for the spoke Storage Account. Default is empty."
  type        = list(string)
  default     = []
}

variable "spoke_storage_containers" {
  type = map(object({
    public_access = optional(string, "None")
    metadata      = optional(map(string))
    name          = string

    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})

    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default     = {}
  description = <<-EOT
 - `container_access_type` - (Optional) The Access Level configured for this Container. Possible values are `Blob`, `Container` or `None`. Defaults to `None`.
 - `metadata` - (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase.
 - `name` - (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.

 Supply role assignments in the same way as for `var.role_assignments`.

 ---
 `timeouts` block supports the following:
 - `create` - (Defaults to 30 minutes) Used when creating the Storage Container.
 - `delete` - (Defaults to 30 minutes) Used when deleting the Storage Container.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Storage Container.
 - `update` - (Defaults to 30 minutes) Used when updating the Storage Container.
EOT
  nullable    = false
}

variable "spoke_storage_user_assigned_resource_ids" {
  description = "This is to assign user assigned identities. This is not used for Customer Managed Keys."
  type = list(string)
  default = null
  
}

variable "existing_private_dns_zone_blob_id" {
  description = "The ID of the existing Private DNS Zone for the Blob service for the Storage Account. Default is null."
  type        = list(string)
  default     = null
}