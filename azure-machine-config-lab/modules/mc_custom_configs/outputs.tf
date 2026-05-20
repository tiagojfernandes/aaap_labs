output "policy_assignment_ids" {
  description = "Map of custom policy assignment names to their IDs"
  value       = { for k, v in azurerm_resource_group_policy_assignment.custom_gc : k => v.id }
}

output "policy_assignment_identity_principal_ids" {
  description = "Map of custom policy assignment names to their identity principal IDs"
  value       = { for k, v in azurerm_resource_group_policy_assignment.custom_gc : k => v.identity[0].principal_id }
}

output "remediation_ids" {
  description = "Map of remediation task names to their IDs"
  value       = { for k, v in azurerm_resource_group_policy_remediation.custom_gc : k => v.id }
}
