#########################################
# Resource Naming Configuration
#########################################
variable "resource_name_config" {
  description = "Configuration for standardized resource naming"
  type = object({
    resource_type = string
    application   = string
    environment   = string
    region        = string
    cloud         = string
    instance      = string
    use_hyphen    = bool
  })

  validation {
    condition = (
      length(trimspace(var.resource_name_config.resource_type)) > 0 &&
      length(trimspace(var.resource_name_config.application)) > 0 &&
      length(trimspace(var.resource_name_config.environment)) > 0 &&
      length(trimspace(var.resource_name_config.region)) > 0 &&
      length(trimspace(var.resource_name_config.cloud)) > 0 &&
      length(trimspace(var.resource_name_config.instance)) > 0
    )
    error_message = "All naming convention fields are mandatory."
  }

  validation {
    condition     = contains(["az", "aws", "gcp"], lower(var.resource_name_config.cloud))
    error_message = "cloud must be az, aws or gcp."
  }

  validation {
    condition     = can(regex("^[0-9]{2}$", var.resource_name_config.instance))
    error_message = "instance must be two digits. Example: 01."
  }

  validation {
    condition     = var.resource_name_config.resource_type == lower(var.resource_name_config.resource_type)
    error_message = "resource_type must be provided in lowercase. Example: vm, vnet, stg, sql."
  }

  validation {
    condition     = contains(["dev", "test", "uat", "prod"], lower(var.resource_name_config.environment))
    error_message = "environment must be one of: dev, test, uat, prod."
  }

}

#########################################
# Mandatory Governance Tags
#########################################
variable "mandatory_tags" {
  description = "Mandatory governance tags required for all resources"
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

  validation {
    condition     = length(trimspace(var.mandatory_tags.environment_type)) > 0
    error_message = "environment_type cannot be empty."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9 -]+$", var.mandatory_tags.department))
    error_message = "department may contain only letters, numbers, spaces, and hyphens."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9._%+-]+@burlington\\.com$", var.mandatory_tags.owner_email))
    error_message = "owner_email must be a valid @burlington.com email address."
  }

  validation {
    condition     = length(trimspace(var.mandatory_tags.app)) > 0
    error_message = "app  cannot be empty."
  }

  validation {
    condition     = can(regex("^Email:[A-Za-z0-9._%+-]+@burlington\\.com\\+Teams:[A-Za-z0-9_-]+$", var.mandatory_tags.change_notification))
    error_message = "change_notification must follow format: Email:cm@burlington.com+Teams:changemanagement."
  }

  validation {
    condition     = can(regex("^[a-z]{3}-[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}$", lower(var.mandatory_tags.maintenance_window)))
    error_message = "maintenance_window must follow format: sun-00:00-04:00."
  }

  validation {
    condition     = contains(["low", "medium", "high", "mission-critical"], lower(var.mandatory_tags.criticality))
    error_message = "criticality must be one of: low, medium, high, mission-critical."
  }

  validation {
    condition     = contains(["sensitive", "confidential", "official-use", "public"], lower(var.mandatory_tags.data_classification))
    error_message = "data_classification must be one of: sensitive, confidential, official-use, public."
  }

}

#########################################
# Resource Specific Tags
#########################################
variable "resource_specific_tags" {
  description = "Tags specific to resource type (e.g., backup-policy, patch-group)"
  type        = map(string)
}

#########################################
# Optional Tags
#########################################
variable "optional_tags" {
  description = "Optional additional tags"
  type        = map(string)
  default     = {}
}

#########################################
# Custom Tags
#########################################
variable "custom_tags" {
  description = "Custom user-defined tags"
  type        = map(string)
  default     = {}
}

#########################################
# Workflow Tags
#########################################
variable "workflow_tags" {
  description = "Platform workflow generated tags"
  type        = map(string)
  default     = {}
}