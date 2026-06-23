output "id" {
  description = "Virtual network id"
  value       = [for vnet in azurerm_virtual_network.vnet : vnet.id]
}

output "name" {
  description = "Virtual network name"
  value       = [for vnet in azurerm_virtual_network.vnet : vnet.name]
}

output "location" {
  description = "Virtual network location"
  value       = [for vnet in azurerm_virtual_network.vnet : vnet.location]
}

output "address_space" {
  description = "Virtual network address space"
  value       = [for vnet in azurerm_virtual_network.vnet : vnet.address_space]
}

output "subnets" {
  description = "Virtual network subnets"
  value       = azurerm_subnet.subnets
}

output "vnet_created" {
  value      = true
  depends_on = [azurerm_subnet.subnets]
}

output "vnets" {
  description = "Map of virtual networks keyed by name"
  value = {
    for vnet in azurerm_virtual_network.vnet :
    vnet.name => {
      id            = vnet.id
      name          = vnet.name
      location      = vnet.location
      address_space = vnet.address_space
    }
  }
}