# Machine Configuration - Custom Configurations Module
# Your playground for custom Machine Configuration policies.
#
# Takes one or more policy definition IDs that represent guest configuration policies
# and assigns them at RG scope with a configurable effect:
# - Audit / AuditIfNotExists: Just report compliance
# - DeployIfNotExists: Apply and monitor (auto-deploy)
# - You can emulate ApplyAndMonitor / ApplyAndAutoCorrect behavior
#
# Designed for plugging in:
# - TLS hardening config
# - MDE-style hardening config
# - SSH hardening for Linux
# - Windows security hardening
# - Custom DSC configurations

# Dynamic policy assignments for custom Guest Configuration policies
resource "azurerm_resource_group_policy_assignment" "custom_gc" {
  for_each = var.custom_policy_assignments

  name                 = each.key
  resource_group_id    = var.resource_group_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description

  identity {
    type = "SystemAssigned"
  }

  location = var.location

  # Dynamic parameters block
  parameters = each.value.parameters != null ? jsonencode(each.value.parameters) : null

  non_compliance_message {
    content = each.value.non_compliance_message != null ? each.value.non_compliance_message : "Resource does not comply with ${each.value.display_name}"
  }
}

# Role assignments for policy remediation (needed for DeployIfNotExists)
resource "azurerm_role_assignment" "custom_gc_contributor" {
  for_each = { for k, v in var.custom_policy_assignments : k => v if v.needs_remediation }

  scope                = var.resource_group_id
  role_definition_name = each.value.role_definition_name != null ? each.value.role_definition_name : "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.custom_gc[each.key].identity[0].principal_id
}

# Optional remediation tasks for existing non-compliant resources
resource "azurerm_resource_group_policy_remediation" "custom_gc" {
  for_each = { for k, v in var.custom_policy_assignments : k => v if v.create_remediation }

  name                 = "${each.key}-remediation"
  resource_group_id    = var.resource_group_id
  policy_assignment_id = azurerm_resource_group_policy_assignment.custom_gc[each.key].id
}
