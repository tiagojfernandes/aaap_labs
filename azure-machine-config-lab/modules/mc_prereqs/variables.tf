variable "resource_group_id" {
  description = "The ID of the resource group to assign the policy to"
  type        = string
}

variable "location" {
  description = "Azure region for the policy assignment identity"
  type        = string
}

variable "assignment_name" {
  description = "Name of the policy assignment"
  type        = string
  default     = "mc-prereqs"
}

variable "assignment_display_name" {
  description = "Display name of the policy assignment"
  type        = string
  default     = "Deploy prerequisites for Guest Configuration policies"
}

variable "prereqs_initiative_id" {
  description = "The policy set (initiative) definition ID for MC prerequisites. Default is the built-in 'Deploy prerequisites to enable Guest Configuration policies on virtual machines' initiative."
  type        = string
  # Built-in initiative: Deploy prerequisites to enable Guest Configuration policies on virtual machines
  default = "/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8"
}

variable "create_remediation_task" {
  description = "Whether to create a remediation task to apply prerequisites to existing VMs"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources (used for naming consistency)"
  type        = map(string)
  default     = {}
}
