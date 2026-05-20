variable "resource_group_id" {
  description = "The ID of the resource group to assign custom policies to"
  type        = string
}

variable "location" {
  description = "Azure region for the policy assignment identities"
  type        = string
}

variable "custom_policy_assignments" {
  description = <<-EOT
    Map of custom Guest Configuration policy assignments.
    Each entry should specify:
    - policy_definition_id: The policy or initiative definition ID
    - display_name: Human-readable name
    - description: Description of what this policy does
    - parameters: Optional parameters for the policy (as a map)
    - needs_remediation: Whether this policy needs a role assignment for remediation (DeployIfNotExists)
    - role_definition_name: Role to assign for remediation (default: Contributor)
    - create_remediation: Whether to create a remediation task for existing resources
    - non_compliance_message: Custom message for non-compliant resources
    
    Example assignments for future use:
    - TLS hardening: Audit/enforce TLS 1.2+
    - SSH hardening: Enforce key-based auth, disable root login
    - Windows hardening: Password policies, audit policies
  EOT
  type = map(object({
    policy_definition_id   = string
    display_name           = string
    description            = optional(string, "Custom Guest Configuration policy assignment")
    parameters             = optional(map(any), null)
    needs_remediation      = optional(bool, false)
    role_definition_name   = optional(string, "Contributor")
    create_remediation     = optional(bool, false)
    non_compliance_message = optional(string, null)
  }))
  default = {}
}

# Example variable structure for common hardening scenarios:
#
# custom_policy_assignments = {
#   "tls-hardening" = {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/xxx"
#     display_name         = "TLS 1.2+ Enforcement"
#     description          = "Ensure TLS 1.2 or higher is used for secure connections"
#     needs_remediation    = true
#     create_remediation   = true
#   }
#   
#   "ssh-key-only" = {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/yyy"
#     display_name         = "SSH Key-Based Authentication Only"
#     description          = "Linux VMs should use SSH key authentication, not passwords"
#     needs_remediation    = false
#   }
#   
#   "windows-password-policy" = {
#     policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/zzz"
#     display_name         = "Windows Password Policy"
#     description          = "Enforce strong password requirements on Windows VMs"
#     parameters = {
#       MinimumPasswordLength = { value = 14 }
#       PasswordComplexity    = { value = "Enabled" }
#     }
#     needs_remediation    = true
#     create_remediation   = true
#   }
# }
