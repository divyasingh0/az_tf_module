terraform {
  required_version = ">= 1.3.0"
}

locals {
  #########################################################
  # Sanitized Naming Components
  #########################################################
  sanitized_name_parts = [
    for value in [
      var.resource_name_config.resource_type,
      var.resource_name_config.application,
      var.resource_name_config.environment,
      var.resource_name_config.region,
      var.resource_name_config.cloud,
      var.resource_name_config.instance
    ] :
    lower(join("", regexall("[a-z0-9]", tostring(value))))
  ]

  #########################################################
  # Standard vs Compact Name
  #########################################################
  standard_name = join("-", local.sanitized_name_parts)
  compact_name  = replace(local.standard_name, "-", "")

  #########################################################
  # Final Resource Name
  #########################################################
  final_resource_name = var.resource_name_config.use_hyphen ? local.standard_name : local.compact_name
}

#########################################################
# Governance Mandatory Tags
#########################################################
locals {
  governance_tags = {
    EnvironmentType    = var.mandatory_tags.environment_type
    Department         = var.mandatory_tags.department
    OwnerEmail         = var.mandatory_tags.owner_email
    Tool               = var.mandatory_tags.tool
    Terraform          = var.mandatory_tags.terraform
    App                = var.mandatory_tags.app
    ChangeNotification = var.mandatory_tags.change_notification
    MaintenanceWindow  = var.mandatory_tags.maintenance_window
    Criticality        = var.mandatory_tags.criticality
    DataClassification = var.mandatory_tags.data_classification
  }
}

#########################################################
# Resource Specific Validation
#########################################################
locals {
  vm_requires_patch_group = (
    lower(var.resource_name_config.resource_type) == "vm"
    && !contains(keys(var.resource_specific_tags), "patch-group")
  )

  storage_requires_backup_policy = (
    contains(["stg", "sql", "db"], lower(var.resource_name_config.resource_type))
    && !contains(keys(var.resource_specific_tags), "backup-policy")
  )
}

resource "terraform_data" "tag_validation" {
  lifecycle {
    precondition {
      condition     = !local.vm_requires_patch_group
      error_message = "patch-group tag is mandatory for VM resources."
    }
    precondition {
      condition     = !local.storage_requires_backup_policy
      error_message = "backup-policy tag is mandatory for Storage and Database resources."
    }
  }
}

#########################################################
# Final Tags (merge + cleanup)
#########################################################
locals {
  merged_tags = merge(
    local.governance_tags,
    var.workflow_tags,
    var.resource_specific_tags,
    var.optional_tags,
    var.custom_tags
  )

  final_tags = {
    for key, value in local.merged_tags :
    lower(trimspace(key)) => trimspace(tostring(value))
    if(value != null && trimspace(tostring(value)) != "")
  }
}
 