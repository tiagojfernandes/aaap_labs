# Machine Configuration Prerequisites Module
# Assigns the built-in "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
# initiative at Resource Group scope.
#
# This initiative deploys:
# - Machine Configuration (Guest Configuration) extension/agent
# - System-assigned managed identity on VMs
# - Other prerequisites for Guest Configuration policies to work

# Policy Assignment for MC Prerequisites Initiative
resource "azurerm_resource_group_policy_assignment" "mc_prereqs" {
  name                 = var.assignment_name
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.prereqs_initiative_id
  display_name         = var.assignment_display_name
  description          = "Deploys prerequisites to enable Guest Configuration policies on virtual machines in this resource group"

  identity {
    type = "SystemAssigned"
  }

  location = var.location

  # Non-compliance messages
  non_compliance_message {
    content = "VM does not have the required prerequisites for Machine Configuration policies."
  }
}

# Role assignment for the policy to remediate resources
# The initiative needs Contributor to deploy extensions and managed identities
resource "azurerm_role_assignment" "mc_prereqs_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.mc_prereqs.identity[0].principal_id
}

# Optional: Create remediation task to apply prerequisites to existing VMs
resource "azurerm_resource_group_policy_remediation" "mc_prereqs" {
  count = var.create_remediation_task ? 1 : 0

  name                 = "${var.assignment_name}-remediation"
  resource_group_id    = var.resource_group_id
  policy_assignment_id = azurerm_resource_group_policy_assignment.mc_prereqs.id
}
