# Machine Configuration - MDC / Microsoft Cloud Security Benchmark Baseline Module
# Assigns security baseline initiative(s) at Resource Group scope.
#
# This lights up "vulnerabilities in security configuration... (powered by Guest Configuration)"
# in Microsoft Defender for Cloud for this RG only.
#
# You can assign:
# - Microsoft Cloud Security Benchmark (MCSB) initiative
# - Windows security baseline initiative
# - Linux security baseline initiative

# Primary MDC/MCSB Initiative Assignment
resource "azurerm_resource_group_policy_assignment" "mdc_baseline" {
  count = var.enable_mdc_baseline ? 1 : 0

  name                 = var.mdc_assignment_name
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.mdc_initiative_id
  display_name         = var.mdc_assignment_display_name
  description          = "Microsoft Defender for Cloud / Microsoft Cloud Security Benchmark baseline for Guest Configuration"

  identity {
    type = "SystemAssigned"
  }

  location = var.location

  non_compliance_message {
    content = "Resource does not comply with MDC security baseline requirements."
  }
}

# Windows Security Baseline Initiative Assignment
resource "azurerm_resource_group_policy_assignment" "windows_baseline" {
  count = var.enable_windows_baseline ? 1 : 0

  name                 = var.windows_assignment_name
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.windows_baseline_initiative_id
  display_name         = var.windows_assignment_display_name
  description          = "Windows security baseline configuration powered by Guest Configuration"

  identity {
    type = "SystemAssigned"
  }

  location = var.location

  non_compliance_message {
    content = "Windows VM does not comply with security baseline requirements."
  }
}

# Linux Security Baseline Initiative Assignment
resource "azurerm_resource_group_policy_assignment" "linux_baseline" {
  count = var.enable_linux_baseline ? 1 : 0

  name                 = var.linux_assignment_name
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.linux_baseline_initiative_id
  display_name         = var.linux_assignment_display_name
  description          = "Linux security baseline configuration powered by Guest Configuration"

  identity {
    type = "SystemAssigned"
  }

  location = var.location

  non_compliance_message {
    content = "Linux VM does not comply with security baseline requirements."
  }
}

# Role assignments for policy remediation
resource "azurerm_role_assignment" "mdc_contributor" {
  count = var.enable_mdc_baseline ? 1 : 0

  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.mdc_baseline[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "windows_contributor" {
  count = var.enable_windows_baseline ? 1 : 0

  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.windows_baseline[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "linux_contributor" {
  count = var.enable_linux_baseline ? 1 : 0

  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.linux_baseline[0].identity[0].principal_id
}
