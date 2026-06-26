
# variable "ddosplan" {
#   type = map(object({
#     name     = string
#     rg_name  = string
#     location = string
#   }))
#   description = "DDOS Protection Plan"
# }

variable "vnets" {
  type = map(object({
    vnet_name          = string
    vnet_rgname        = string
    vnet_location      = string
    vnet_address_space = list(string)
    dns_servers        = optional(list(string))
    enable_ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))
  }))
  description = "Virtual Networks"
}

variable "subnets" {
  type = map(object({
    subnet_name                                   = string
    subnet_address_prefixes                       = list(string)
    subnet_rgname                                 = string
    vnet_name                                     = string
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool, false)
    service_endpoints                             = optional(list(string))
    subnet_delegation_name                        = string
    subnet_service_delegation_name                = optional(string)
    subnet_service_delegation_actions             = optional(list(string))
  }))
  description = "Azure Subnets"
}