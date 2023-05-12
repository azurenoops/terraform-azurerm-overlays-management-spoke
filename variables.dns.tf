# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "private_dns_zones" {
  description = "A list of private dns zones to link to the spoke vnet. It is usaully the same list in the spoke vnet"
  type = list(string)
  default = null
}
  
   