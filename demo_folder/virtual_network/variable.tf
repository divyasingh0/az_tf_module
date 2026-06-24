
# variable "ddosplan" {
#   type = map(object({
#     name     = string
#     rg_name  = string
#     location = string
#   }))
#   description = "DDOS Protection Plan"
# }

# variable "vnets" {
#   type = map(object({
#     vnet_name          = string
#     vnet_rgname        = string
#     vnet_location      = string
#     vnet_address_space = list(string)
#     dns_servers        = optional(list(string))
#     enable_ddos_protection_plan = optional(object({
#       id     = string
#       enable = bool
#     }))
#   }))
#   description = "Virtual Networks"
# }

variable "subnets" {
  type = map(object({
    subnet_name                                   = string
    subnet_address_prefixes                       = list(string)
    subnet_rgname                                 = string
    vnet_key                                    = string
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool, false)
    service_endpoints                             = optional(list(string))
    subnet_delegation_name                        = string
    subnet_service_delegation_name                = optional(string)
    subnet_service_delegation_actions             = optional(list(string))
  }))
  description = "Azure Subnets"
}

resource "terraform_data" "subnet_validation" {
  for_each = var.subnets

  lifecycle {
    precondition {
      condition     = contains(keys(var.vnets), each.value.vnet_key)
      error_message = "Subnet references a vnet_key that does not exist."
    }
  }
}





#########################################################
# VNets + Governance (MERGED)
#########################################################
variable "vnets" {
  description = "Virtual Networks with Governance"
  type = map(object({

    #################################################
    # VNet Core
    #################################################
    # vnet_name          = string
    vnet_rgname        = string
    vnet_location      = string
    vnet_address_space = list(string)
    dns_servers        = optional(list(string))

    enable_ddos_protection_plan = optional(object({
      id     = optional(string)
      enable = optional(bool)
    }))

    #################################################
    # Governance: Naming
    #################################################
    resource_name_config = object({
      resource_type = string
      application   = string
      environment   = string
      region        = string
      cloud         = string
      instance      = string
      use_hyphen    = bool
    })

    #################################################
    # Governance: Mandatory Tags
    #################################################
    mandatory_tags = object({
      environment_type    = string
      department          = string
      owner_email         = string
      tool                = string
      terraform           = string
      app                 = string
      change_notification = string
      maintenance_window  = string
      criticality         = string
      data_classification = string
    })

    #################################################
    # Governance: Other Tags
    #################################################
    resource_specific_tags = map(string)
    optional_tags          = map(string)
    custom_tags            = map(string)
  }))
}