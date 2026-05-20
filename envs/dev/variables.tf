# Development Environment Variables

#------------------------------------------------------------------------------
# Azure Subscription
#------------------------------------------------------------------------------
variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
}

#------------------------------------------------------------------------------
# General
#------------------------------------------------------------------------------
variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the resource group (lab boundary)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create for the lab VMs"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    default = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

variable "allow_rdp" {
  description = "Whether to allow RDP access from allowed IPs"
  type        = bool
  default     = true
}

variable "allow_ssh" {
  description = "Whether to allow SSH access from allowed IPs"
  type        = bool
  default     = true
}

variable "allowed_source_ips" {
  description = "List of source IP addresses allowed for RDP/SSH access (e.g., your public IP)"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# Compute - Windows
#------------------------------------------------------------------------------
variable "windows_vm_name" {
  description = "Name of the Windows VM"
  type        = string
}

variable "create_windows_public_ip" {
  description = "Whether to create a public IP for the Windows VM"
  type        = bool
  default     = false
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
}

variable "admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}

#------------------------------------------------------------------------------
# Compute - Linux
#------------------------------------------------------------------------------
variable "linux_vm_name" {
  description = "Name of the Linux VM"
  type        = string
}

variable "create_linux_public_ip" {
  description = "Whether to create a public IP for the Linux VM"
  type        = bool
  default     = false
}

variable "admin_ssh_key" {
  description = "SSH public key for Linux VM authentication"
  type        = string
  default     = null
}

variable "linux_admin_password" {
  description = "Admin password for Linux VM (used if SSH key not provided)"
  type        = string
  sensitive   = true
  default     = null
}

#------------------------------------------------------------------------------
# Compute - Common
#------------------------------------------------------------------------------
variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_DS1_v2"
}

#------------------------------------------------------------------------------
# Monitoring
#------------------------------------------------------------------------------
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "dcr_name" {
  description = "Name of the Data Collection Rule"
  type        = string
}

#------------------------------------------------------------------------------
# Machine Configuration - Prerequisites
#------------------------------------------------------------------------------
variable "mc_prereqs_assignment_name" {
  description = "Name of the MC prerequisites policy assignment"
  type        = string
  default     = "mc-prereqs"
}

variable "mc_prereqs_initiative_id" {
  description = "Policy initiative ID for MC prerequisites (defaults to built-in)"
  type        = string
  default     = "/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8"
}

variable "create_mc_prereqs_remediation" {
  description = "Whether to create a remediation task for MC prerequisites"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Machine Configuration - MDC Baseline
#------------------------------------------------------------------------------
variable "enable_mdc_baseline" {
  description = "Enable Microsoft Cloud Security Benchmark initiative"
  type        = bool
  default     = false
}

variable "enable_windows_baseline" {
  description = "Enable Windows security baseline initiative"
  type        = bool
  default     = true
}

variable "enable_linux_baseline" {
  description = "Enable Linux security baseline initiative"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# Machine Configuration - Custom Configs
#------------------------------------------------------------------------------
variable "custom_policy_assignments" {
  description = <<-EOT
    Map of custom Guest Configuration policy assignments.
    Use this to plug in:
    - TLS hardening config
    - MDE-style hardening config
    - SSH hardening for Linux
    - Windows security hardening
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
