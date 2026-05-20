variable "resource_group_id" {
  description = "The ID of the resource group to assign baseline policies to"
  type        = string
}

variable "location" {
  description = "Azure region for the policy assignment identities"
  type        = string
}

# MDC / MCSB Baseline
variable "enable_mdc_baseline" {
  description = "Enable Microsoft Cloud Security Benchmark initiative assignment"
  type        = bool
  default     = false
}

variable "mdc_assignment_name" {
  description = "Name of the MDC baseline policy assignment"
  type        = string
  default     = "mdc-mcsb-baseline"
}

variable "mdc_assignment_display_name" {
  description = "Display name of the MDC baseline policy assignment"
  type        = string
  default     = "Microsoft Cloud Security Benchmark"
}

variable "mdc_initiative_id" {
  description = "The initiative (policy set) definition ID for Microsoft Cloud Security Benchmark"
  type        = string
  # Built-in: Microsoft Cloud Security Benchmark
  default = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
}

# Windows Baseline
variable "enable_windows_baseline" {
  description = "Enable Windows security baseline initiative assignment"
  type        = bool
  default     = true
}

variable "windows_assignment_name" {
  description = "Name of the Windows baseline policy assignment"
  type        = string
  default     = "windows-security-baseline"
}

variable "windows_assignment_display_name" {
  description = "Display name of the Windows baseline policy assignment"
  type        = string
  default     = "Windows Security Baseline (Guest Configuration)"
}

variable "windows_baseline_initiative_id" {
  description = "The policy definition ID for Windows security baseline"
  type        = string
  # Built-in: Windows machines should meet requirements of the Azure compute security baseline
  default = "/providers/Microsoft.Authorization/policyDefinitions/72650e9f-97bc-4b2a-ab5f-9781a9fcecbc"
}

# Linux Baseline
variable "enable_linux_baseline" {
  description = "Enable Linux security baseline policy assignment"
  type        = bool
  default     = true
}

variable "linux_assignment_name" {
  description = "Name of the Linux baseline policy assignment"
  type        = string
  default     = "linux-security-baseline"
}

variable "linux_assignment_display_name" {
  description = "Display name of the Linux baseline policy assignment"
  type        = string
  default     = "Linux Security Baseline (Guest Configuration)"
}

variable "linux_baseline_initiative_id" {
  description = "The policy definition ID for Linux security baseline"
  type        = string
  # Built-in: Linux machines should meet requirements for the Azure compute security baseline
  default = "/providers/Microsoft.Authorization/policyDefinitions/fc9b3da7-8347-4380-8e70-0a0361d8dedd"
}
