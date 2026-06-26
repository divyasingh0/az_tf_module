terraform {
  required_version = ">= 1.3.0"
}

# resource "azurerm_network_ddos_protection_plan" "ddos" {
#   count = var.enable_ddos_protection_plan == true ? 1 : 0

#   name                = "${var.name}_ddosplan1"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.key
  resource_group_name = each.value.vnet_rgname
  location            = each.value.vnet_location
  address_space       = each.value.vnet_address_space
  dns_servers         = each.value.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = each.value.enable_ddos_protection_plan == true ? [1] : []

    content {
      id     = each.value.enable_ddos_protection_plan.id
      enable = each.value.enable_ddos_protection_plan.enable
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name             = each.key
  address_prefixes = each.value.subnet_address_prefixes

  resource_group_name  = each.value.subnet_rgname
  virtual_network_name = each.value.vnet_name

  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.subnet_delegation_name != "" ? [1] : []

    content {
      name = each.value["subnet_delegation_name"]
      service_delegation {
        name    = each.value["subnet_service_delegation_name"]
        actions = each.value["subnet_service_delegation_actions"]
      }
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}