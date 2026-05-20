output "policy_assignment_id" {
  description = "The ID of the MC prerequisites policy assignment"
  value       = azurerm_resource_group_policy_assignment.mc_prereqs.id
}

output "policy_assignment_name" {
  description = "The name of the MC prerequisites policy assignment"
  value       = azurerm_resource_group_policy_assignment.mc_prereqs.name
}

output "policy_assignment_identity_principal_id" {
  description = "The principal ID of the policy assignment's managed identity"
  value       = azurerm_resource_group_policy_assignment.mc_prereqs.identity[0].principal_id
}

output "remediation_id" {
  description = "The ID of the remediation task (if created)"
  value       = var.create_remediation_task ? azurerm_resource_group_policy_remediation.mc_prereqs[0].id : null
}
