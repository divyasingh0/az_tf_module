output "final_resource_name" {
  description = "Final resource name following governance rules"
  value       = local.final_resource_name
}

output "final_tags" {
  description = "Final merged tags with governance priority"
  value       = local.final_tags
}
 