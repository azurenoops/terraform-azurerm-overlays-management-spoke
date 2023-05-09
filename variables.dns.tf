# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "private_dns_zones_to_link_to_hub" {
  description = "A list of private dns zones to link to the hub vnet. It is usaully the same list in the hub vnet"
  type = list(string)
  default = null
}
  
   