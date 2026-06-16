output "id" {

  description = "Storage Account ID"

  value       = { for stgaccount in azurerm_storage_account.stgaccount : stgaccount.name => stgaccount.id }

}
 
output "name" {

  description = "Storage Account Name"

  value       = { for stgaccount in azurerm_storage_account.stgaccount : stgaccount.name => stgaccount.name }

}
 
output "primary_location" {

  description = "Location of the Storage Account"

  value       = { for stgaccount in azurerm_storage_account.stgaccount : stgaccount.name => stgaccount.primary_location }

}
 
output "primary_blob_endpoint" {

  description = "Blob endpoint"

  value       = { for stgaccount in azurerm_storage_account.stgaccount : stgaccount.name => stgaccount.primary_blob_endpoint }

}
 
output "primary_access_key" {

  description = "Blob endpoint"

  value       = { for stgaccount in azurerm_storage_account.stgaccount : stgaccount.name => stgaccount.primary_access_key }

}
 