terraform {
  required_version = ">= 1.4.0"
}
 
resource "azurerm_storage_account" "stgaccount" {
  for_each                         = var.storage_accounts
  name                             = each.key
  resource_group_name              = each.value.rgname
  location                         = each.value.location
  account_tier                     = each.value.account_tier
  account_replication_type         = each.value.account_replication_type
  min_tls_version                  = each.value.min_tls_version
  is_hns_enabled                   = each.value.is_hns_enabled
  allow_nested_items_to_be_public  = each.value.allow_nested_items_to_be_public
  sftp_enabled                     = each.value["sftp_enabled"]
  tags                             = each.value["sa_tags"]
  cross_tenant_replication_enabled = each.value.cross_tenant_replication_enabled
 
  blob_properties {
    delete_retention_policy {
      days = each.value["blob_retention_days"]
    }
    container_delete_retention_policy {
      days = each.value["container_retention_days"]
    }
    dynamic "cors_rule" {
      for_each = lookup(each.value, "cors_rules", [])
      content {
        allowed_headers    = try(cors_rule.value.allowed_headers, null)
        allowed_methods    = try(cors_rule.value.allowed_methods, null)
        allowed_origins    = try(cors_rule.value.allowed_origins, null)
        exposed_headers    = try(cors_rule.value.exposed_headers, null)
        max_age_in_seconds = try(cors_rule.value.max_age_in_seconds, null)
      }
    }
  }
 
  dynamic "network_rules" {
    for_each = try(each.value.network_rules, null) != null ? [1] : []
    content {
      default_action             = each.value.network_rules.default_action == "" ? null : each.value.network_rules.default_action
      ip_rules                   = each.value.network_rules.ip_rules == "" ? null : each.value.network_rules.ip_rules
      virtual_network_subnet_ids = each.value.network_rules.virtual_network_subnet_ids == "" ? null : each.value.network_rules.virtual_network_subnet_ids
      bypass                     = each.value.network_rules.bypass == "" ? null : each.value.network_rules.bypass
 
      dynamic "private_link_access" {
        for_each = coalesce(lookup(each.value.network_rules, "private_link_access", null), [])
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }
  
 
  lifecycle {
    ignore_changes = [customer_managed_key, timeouts]
  }
}