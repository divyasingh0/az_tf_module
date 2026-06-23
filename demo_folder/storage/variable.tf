# #############################################################################
# # Storage Accounts
# #############################################################################

variable "storage_accounts" {
  description = "Storage accounts"
  type = map(object({
    # accntname                        = string
    rgname                           = string
    instance                         = string
    location                         = string
    account_tier                     = string
    account_replication_type         = string
    min_tls_version                  = optional(string, "TLS1_2")
    allow_nested_items_to_be_public  = bool
    is_hns_enabled                   = optional(bool)
    blob_retention_days              = optional(string)
    container_retention_days         = optional(string)
    sftp_enabled                     = optional(bool)
    cross_tenant_replication_enabled = optional(bool)
    identity = optional(object({
      type         = string                 # "SystemAssigned" or "UserAssigned"
      identity_ids = optional(list(string)) # Required if type = "UserAssigned"
      principal_id = optional(string)
      tenant_id    = optional(string)
    }))

   
    network_rules = optional(object({
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
      bypass                     = optional(list(string))
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = string
      })))
    }))

    cors_rules = optional(list(object({
      allowed_headers    = optional(list(string))
      allowed_methods    = optional(list(string))
      allowed_origins    = optional(list(string))
      exposed_headers    = optional(list(string))
      max_age_in_seconds = optional(number)
    })), [])

    #################################################
    # Governance Tags
    #################################################

    resource_specific_tags = optional(map(string), {})

    optional_tags = optional(map(string), {})

    custom_tags = optional(map(string), {})

  }))
}



#############################################################################
# Resource Naming Configuration
#############################################################################

variable "resource_name_config" {

  description = "Enterprise standard naming configuration"

  type = object({

    resource_type = string
    application   = string
    environment   = string
    region        = string
    cloud         = string
    instance      = string
    use_hyphen    = bool

  })

}

#############################################################################
# Mandatory Governance Tags
#############################################################################

variable "mandatory_tags" {

  description = "Mandatory governance tags"

  type = object({

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

}

 